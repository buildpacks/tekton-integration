
function login_as_developer() {
    local url=$(crc console --credentials -o json | jq -r .clusterConfig.url)
    oc login -u developer -p developer ${url}
}

function login_as_admin() {
    local url=$(crc console --credentials -o json | jq -r .clusterConfig.url)
    local admin_username=$(crc console --credentials -o json | jq -r .clusterConfig.adminCredentials.username)
    local admin_password=$(crc console --credentials -o json | jq -r .clusterConfig.adminCredentials.password)
    oc login -u ${admin_username} -p ${admin_password} https://api.crc.testing:6443
}