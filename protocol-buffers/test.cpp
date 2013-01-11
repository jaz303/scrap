#include <iostream>
#include "gen/test.pb.h"

int main(int argc, char *argv[]) {

    Person p;
    p.set_forename("Jason");
    p.set_surname("Frame");
    p.set_salary(1000);
    p.set_status(Person::NORMAL);
    
    Role *r;
    
    r = p.add_roles();
    r->set_id(0);
    r->set_name("Manager");
    
    r = p.add_roles();
    r->set_id(1);
    r->set_name("Chief Cookie Eater");
    
    return 0;
}

