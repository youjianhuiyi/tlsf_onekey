## 全新手工架设环境开服食用指南

### 告别虚拟机开服🎉，告别win机装虚拟机开服🎉，告别win机+Linux机开服🎉。是的你没听错🎉，只需要一个Linux机就可以开服。市面上最小开服的配置机器即可开服🎉。接下来，详细的配置过程如下，有技术问题可以加群：826717146

- #### 先装一个最新的centos7.x系统64位以上（不支持CentOs6）。系统安装过程不进行演示，系统安装完成后执行以下几条命令。

- #### 服务端配置

```SHELl
# step 1 : 开启验证
cd ~/tlsf/aliyun/scripts && ./ssh-server.sh
# 与上面命令分开复制
cd ../billing && ./billing &

# step 2 : 开服
cd ~/tlsf/aliyun/scripts && ./ssh-server.sh
# 与上面命令分开复制
./run.sh

# 或者使用分部方式进行调试
# 打开窗口1
cd ~/tlsf/aliyun/scripts && ./ssh-server.sh
cd ../billing && ./billing &
# 打开窗口2
cd ~/tlsf/aliyun/scripts && ./ssh-server.sh
cd Server && ./shm start
# 打开窗口3
cd ~/tlsf/aliyun/scripts && ./ssh-server.sh
cd Server && ./Login
# 打开窗口4
cd ~/tlsf/aliyun/scripts && ./ssh-server.sh
cd Server && ./World
# 打开窗口5
cd ~/tlsf/aliyun/scripts && ./ssh-server.sh
cd Server && ./Server

# step 3 ：至此服务端环境全部搭建完成，loginPort 13580 gamePort 15680
# 配置登录器，或者单机登录即可
```

- #### 查看是否一键开服成功，分开窗口可以不需要查看，因为一旦报错，相关窗口就会直接有显示

```shell
# 打开窗口1
cd ~/tlsf/aliyun/scripts && ./ssh-game_server.sh
top

# 查看有如下进程，表示开服成功
top - 14:10:18 up 44 min,  0 users,  load average: 0.36, 0.29, 0.13
Tasks:  11 total,   1 running,  10 sleeping,   0 stopped,   0 zombie
Cpu(s):  7.0%us,  3.2%sy,  0.0%ni, 89.7%id,  0.0%wa,  0.0%hi,  0.1%si,  0.0%st

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                     👌  93 root      20   0 2719m 2.0g  48m S 47.3 25.1   2:16.55 Server                  
👌  90 root      20   0  725m 360m 3276 S 23.0  4.5   0:39.32 Login                       
👌  88 root      20   0  592m 523m  94m S  5.0  6.6   0:10.82 World                       
👌  85 root      20   0  459m 331m 209m S  0.3  4.2   0:01.94 ShareMemory                 
     1 root      20   0  4152  328  252 S  0.0  0.0   0:00.05 tail                       
    31 root      20   0 11492 1748 1392 S  0.0  0.0   0:00.04 bash                       
    42 root      20   0 11492  776  416 S  0.0  0.0   0:00.00 bash                       👌  43 root      20   0  437m  10m 2312 S  0.0  0.1   0:00.02 billing                     
    53 root      20   0 11492 1748 1388 S  0.0  0.0   0:00.03 bash                       
   138 root      20   0 11492 1668 1348 S  0.0  0.0   0:00.15 bash                       
   149 root      20   0 14940 1128  904 R  0.0  0.0   0:00.08 top          
```

- #### 配置服务端及相关参数

```shell
# 注意的是，端口 LOGIN_PORT=13580 SERVER_PORT=15680
# 如果需要改端口。则需要将对应端口进行修改
# 数据库客户端管理使用 ip:33060 ip:33061 进行连接
# 数据库密码：123456
```

- #### PHP网站环境架设（即将更新……）请加群826717146关注最新环境

- #### 一键端服务器环境

```shell
# step 1:关闭系统防火墙以及selinux子系统安全设置
systemctl stop firewalld && systemctl disable firewalld && sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config

# step 2: 更新系统组件并安装必要的一些系统工具
sudo yum -y update && yum install -y epel-release yum-utils wget git vim

# Step 3: 添加软件源信息
sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# Step 4: 更新并安装Docker-CE
sudo yum makecache fast && sudo yum -y install docker-ce docker-compose && systemctl enable docker && sudo systemctl start docker 

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://f0tv1cst.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload && sudo systemctl restart docker && sudo reboot

# step 5: 重启服务器完成后，执行一键执行环境下载
cd ~ && git clone https://gitee.com/yulinzhihou/tlsf_onekey.git tlsf && chmod -R 777 ~/tlsf && cd ~/tlsf && cp env-example .env
# step 6: 执行部署命令,一键安装环境，等待10-20分钟左右，出现
docker-compose up -d

# 出现如下表示已经安装完成
Successfully built cdab3aeef0cd
Successfully tagged yulinzhihou/tlsf_gs:v0.1
Creating tlsf_tlbbdb_1      ... done
Creating tlsf_webdb_1       ... done
Creating tlsf_webdb_1       ... 
Creating tlsf_game_server_1 ... done

# step 6: 复制相关配置文件从主机到docker容器里面
docker cp tlbb.tar.gz tlsf_server_1:/home
cd ~/tlsf/scripts && ./ssh-server.sh
cd /home && tar zxf tlbb.tar.gz -C /home && rm -rf /home/tlbb.tar.gz
#
cd ~/tlsf/scripts && ./modify_ini_config.sh
cd ~/tlsf/scripts && ./ssh-server.sh
cd /home && tar zxf ini.tar.gz -C /home/tlbb/Server/Config && chmod -R 777 /home && chown -R root:root /home && rm -rf /home/ini.tar.gz
#
docker cp billingSer.tar.gz tlsf_server_1:/home
cd ~/tlsf/scripts && ./ssh-server.sh
mkdir -p /home/billing && tar zxf billingSer.tar.gz -C /home/billing && chmod -R 777 /home && chown -R root:root /home && rm -rf /home/billingSer.tar.gz
```



- #### 一机多区环境配置（即将更新……）请加群826717146关注最新环境

