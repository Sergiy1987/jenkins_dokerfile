# Инструкция по инсталяции:

1. Cоздаем имедж на сервере с помощью докер файла

```
   docker build -t nedved198725/app_jenkins:latest https://github.com/Sergiy1987/jenkins_dokerfile.git#master
```

2. Далее следует добавить системного пользователя Jenkins на сервер. Этот пользователь будет управлять сервисом Jenkins

```
   sudo groupadd --system jenkins
   sudo useradd -s /sbin/nologin --system -g jenkins jenkins
   sudo usermod -aG docker jenkins
```

3. Создаем рабочую папку для jenkins

```
   sudo mkdir /var/jenkins_home
   sudo chown -R 1000:1000 /var/jenkins_home
```

4. Запуск имеджа

```
   docker run --rm -a STDIN -a STDOUT -a STDERR \
          --hostname http://35.234.149.51 \
          --name jenkins-server \
          --publish 8080:8080 \
          --publish 50000:50000 \
          --volume /var/jenkins_home:/var/jenkins_home \
          nedved198725/app_jenkins:latest
 ```

5. Активация Jenkins

```
    sudo cat /var/jenkins_home/secrets/initialAdminPassword
```
