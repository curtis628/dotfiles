function parse-secret -d "Parses a Base64-encoded k8s secret value into plaintext"
  set -l usage "Usage:\n" \
              "    parse-secret [--namespace NAMESPACE] [--secret SECRET] [--entry SECRET_ENTRY]"
  set -l help " Parses a Base64-encoded k8s secret value into plaintext.\n\n"\
              "Examples:\n"\
              "    #Parse db-credentials secret for 'postgres' entry of prelude namespace to plaintext.\n" \
              "    parse-secret\n\n" \
              "    #Parse db-credentials secret for 'tango-blueprint-db' entry of prelude namespace to plaintext.\n" \
              "    parse-secret --secret db-credentials --entry tango-blueprint-db --namespace=prelude\n\n" \
              "Options:\n" \
              "    --namespace='': The default namespace to use for this kubeconfig. Default: prelude\n" \
              "    --secret='': The k8s secret to use. Default: db-credentials.\n" \
              "    --entry='': The k8s secret's value to parse. Default: postgres.\n\n" \
              "$usage"
  set -l namespace prelude
  set -l secret db-credentials
  set -l entry postgres

  getopts $argv | while read -l key value
    switch $key
      case namespace
        set namespace $value
      case secret
        set secret $value
      case entry
        set entry $value
      case h help
        echo -e $help
        return
      end
  end
  echo "...Parsing $namespace's [secret=$secret] [entry=$entry] to plaintext" 1>&2
  set -l secret_encoded (kubectl --namespace=$namespace get secret $secret --output yaml | grep -E "\s+$entry" | awk '{print $2}')
  # echo "...secret_encoded=$secret_encoded" 1>&2
  set -l secret_decoded (echo $secret_encoded | base64 --decode)
  echo $secret_decoded
end
