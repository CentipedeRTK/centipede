
#!/bin/bash


echo "inpstr1-path       =:@caster.centipede.fr:2101/$MP::" >> /RTKLIB/app/rtkrcv/gcc/rtkrcv.conf
./rtkrcv -s -o rtkrcv.conf
