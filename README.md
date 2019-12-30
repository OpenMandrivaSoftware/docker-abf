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
