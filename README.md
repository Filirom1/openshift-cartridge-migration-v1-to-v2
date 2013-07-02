# Migration

First desactivate node with v1 cartridge. You don't want those nodes to host new v1 applications.

    $ oo-admin-ctl-district -c deactivate-node -n "small_district" -i node1.example.com
    $ oo-admin-ctl-district -c deactivate-node -n "small_district" -i node2.example.com

Then add a new node in the district with v2 cartridge.

    $ oo-admin-ctl-district -c add-node -i node3.example.com -u "51a4c5174b44050d57000001"

To install a cartridge in v2 format : 

    $ oo-admin-cartridge -a install -s /usr/libexec/openshift/cartridges/v2/python/

To check that v2 cartridges are enabled on the node:

    $  oo-cart-version -c show
	Node is currently in v2 mode

	
Make sure that every gears proposed in v1 format is present in v2 format.
To list installed cartridges in v2 format
    
    $ oo-admin-cartridge -l

To check that the broker known the v2 cartridge

    $ mco rpc -q openshift cartridge_repository action=list
    Discovering hosts using the mc method for 2 second(s) .... 3

     * [ ============================================================> ] 3 / 3


    node1.example.com
       output:

    node2.example.com
       output:

    node3.example.com
       output: (atosworldline, tomcat, 7.0, 0.0.1)
               (atosworldline, tomee, 1.5, 0.0.1)
               (redhat, cron, 1.4, 0.0.1)
               (redhat, diy, 0.1, 0.0.1)
               (redhat, haproxy, 1.4, 0.0.1)
               (redhat, jenkins-client, 1.4, 0.0.1)
               (redhat, jenkins, 1.4, 0.0.1)
               (redhat, mongodb, 2.2, 0.2.0)
               (redhat, mysql, 5.1, 0.2.0)
               (redhat, nodejs, 0.6, 0.0.1)
               (redhat, perl, 5.10, 0.0.1)
               (redhat, php, 5.3, 0.0.2)
               (redhat, phpmyadmin, 3.4, 0.0.1)
               (redhat, ruby, 1.9, 0.0.2)

    Finished processing 3 / 3 hosts in 49.39 ms

It OK that v1 node do not print anything.

## Known bug

On CentOS the node cartridge was using the 0.10 version in v2 and 0.6 version in v1. I think this is a bug, so I manually updated this cartridge.

## Migration script

Now you have both v1 nodes and v2 nodes in the same district.
You may want to migrate v1 applications to v2 format.

The following script will destroy the application and recreate it with the same cartridge.
It doesn't dump database, you will have to do it yourself.

    add-admin-key.sh  # upload your ssh public key for a user
    check-v2.sh       # check if the remote SSH_URI use cartridge v2 (it connect with ssh to check)
    get-apps.js       # list apps for a user
    get-apps-v1.sh    # list v1 apps for a user
    get-users.sh      # list all users
    list-apps-v1.sh   # list all v1 apps
    migrate-auto.sh   # automatically migrate apps to v2 format for a given cartridge
    migrate.sh        # manually migrate gears. Use `get-apps-v1.sh` to fill params

## Warning

Don't use this scripts blindly and at your own risks.
But it may help you to write your own migration scripts
