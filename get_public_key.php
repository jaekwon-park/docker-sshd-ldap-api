<?php
// get IP parameter from client
$aParam['ip']	= trim(filter_input(INPUT_GET, 'ip', FILTER_SANITIZE_STRING));

if(!$aParam['ip']) {
     return false;
}

exec('/shell/get_id.sh '.$aParam['ip'], $aId);

if(is_array($aId) && 0 < count($aId)) {

    foreach($aId AS $key => $value) {
        $sFile = '/key/'.trim($value);

        if(is_file($sFile)) {
            $sContents = file_get_contents($sFile);

            print($sContents);
        }
    }
}

?>
