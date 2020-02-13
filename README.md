# docker-abf

How to activate user account:
```bash
source envfile
cd rosa-build
rails c
a=User.find_by_email("email")
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
rails c
Arch.create(name: "arch")
```


How to unlock publishers:
on abfui:
```bash
1. cd /app
2. source envfile
3. cd rosa-build
4. rails console
5. RepositoryStatus.where.not(status: 0).each do |a| a.ready end
```


How to kill stucked build:
Same like in previous point but:
```bash
BuildList.where(id: [362471, 362473]).destroy_all
```
