<?php

/**
 * LDAP Query for Caballo as PHP
 *
 * LDAP Query using ipv4 For SSH Auth. 
 *
 * PHP version 7.1
 *
 * LICENSE: This source file is subject to version 3.01 of the PHP license
 * that is available through the world-wide-web at the following URI:
 * http://www.php.net/license/3_01.txt.  If you did not receive a copy of
 * the PHP License and are unable to obtain it through the web, please
 * send a note to license@php.net so we can mail you a copy immediately.
 *
 * @category   LDAP
 * @package    LDAPAPI
 * @author     kta9611 <kta9611@code-post.com>
 * @author     jaekwon park <jaekwon.park@code-post.com>
 * @copyright  1997-2005 The PHP Group
 * @license    http://www.php.net/license/3_01.txt  PHP License 3.01
 * @version    SVN: $Id$
 * @link       https://github.com/code-post/Caballo
 * @since      File available since Release 0.0.1
 * @deprecated File deprecated in Release 0.0.1
 */

// get enviroment from Shell
$admin_dn = getenv('ADMIN_DN');
$admin_dn_pass = getenv('ADMIN_DN_PASS');
$ldap_base = getenv('LDAP_BASE');

// get IP parameter from client
$aParam['ip']	= trim(filter_input(INPUT_GET, 'ip', FILTER_SANITIZE_STRING));

if(!$aParam['ip']) {
     return false;
}

$command = '/shell/get_id.sh --admin '.$admin_dn.' --pass '.$admin_dn_pass.' --base '.$ldap_base;

// call get_id.sh shell script using ip to return id 
exec($command.' --server '.$aParam['ip'], $aId);

// return public key using id 
// check id array
if(is_array($aId) && 0 < count($aId)) {
    
    // read public key to using id array
    foreach($aId AS $key => $value) {
        $sFile = '/key/'.trim($value);

        // retrun public key to public key is exist
        if(is_file($sFile)) {
            $sContents = file_get_contents($sFile);
            print($sContents);
        }
    }
}

?>
