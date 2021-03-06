select '', 
       (select ZEMG_PROVISIONING.PROVISION_STRING as "@ProvisionString", 
               ZEMG_PROVISIONING.USERNAME         as username, 
               CUSTOMERS.ZAND_FEED                as url 
        from   ZEMG_PROVISIONING, 
               CUSTOMERS 
        WHERE  ZEMG_PROVISIONING.CUST = CUSTOMERS.CUST 
               AND USERID <> 0 
ORDER BY ZEMG_PROVISIONING.CUST
        FOR XML path('user'), type) 
for xml path('devices'), type  