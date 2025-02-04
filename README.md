# docker-abf

How to update https certs:
This command updates certificates for
abf.openmandriva.org and for file-store.openmandriva.org
config lays in /root/.getssl/

```bash
getssl -f abf.openmandriva.org
cp /etc/ssl/abf.openmandriva.org.crt /var/lib/openmandriva/docker-abf/abf-nginx/
cp /etc/ssl/abf.openmandriva.org.key /var/lib/openmandriva/docker-abf/abf-nginx/
cp /etc/ssl/full_chain.pem /var/lib/openmandriva/docker-abf/abf-nginx/abf.openmandriva.org-chain.pem
```


How to activate user account:
```bash
source envfile
cd rosa-build
bundle exec rails c
a=User.find_by_email("email")
or by name
User.find_by(uname: 'studebakerguy').confirm
a.confirmed_at = Time.now
a.save
```

or just open

```bash
https://abf.openmandriva.org/users/confirmation?confirmation_token=TOKEN_HERE
```

How to add new arch:
```bash
source envfile
cd rosa-build
bundle exec rails c
Arch.create(name: "arch")
```


How to unlock publishers:
on abfui:
```bash
1. cd /app
2. source envfile
3. cd rosa-build
4. bundle exec rails c
5. RepositoryStatus.where.not(status: 0).each do |a| a.ready end
```
How to unlock publishers:
on rosa abfui:
```bash
# docker exec -ti abf_ui_id sh
# bundle exec rails c
# RepositoryStatus.where.not(status: 0).each do |a| a.ready end
```

How to kill stucked build:
Same like in previous point but:
```bash
BuildList.where(id: [362471, 362473]).destroy_all
```
How to force republish massbuild:

```bash
1. bundle exec rails c
2. BuildList.where(mass_build_id: [16, 18]).where(status: BuildList::BUILD_PUBLISHED).find_each do |bl| bl.publish end; true
```
