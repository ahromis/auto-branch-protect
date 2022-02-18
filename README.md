# Automatic Branch Protection

This is a service that listens to GitHub organization events. When a new repository is created the service will automatically enable branch protection on the default branch. It will then notify the repository creator of the enabled branch protections with a `@mention` by creating an issue within the repository.

## Prerequisites

### Create GitHub Webhook

Create a GitHub  webhook in your organization by following the documentation [here](https://docs.github.com/en/developers/webhooks-and-events/webhooks/creating-webhooks#setting-up-a-webhook). Note that this needs to be created at the organization level.

1. For **Payload URL**
    1. Allow external ingress traffic on port 9000 to the host where this service will be running. It should look similar to: `http://webhooks.example.com:9000/hooks/branch-protection`
1. Set **Content type** to **application/json**
1. Set the webhook secret to any value (make note of this value, it will be used later)
1. On the radio dial under **Which events would you like to trigger this webhook?**
    1. Select **Let me select individual events**
    1. Select **Repositories**

### Create GitHub Personal Access Token (PAT)

- Follow the documentation [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) to create a PAT for use with this webhook service. Make note of the token value as it will be used later.

### Install Container Runtime

This service uses a lightweight webhook server called [webhook](https://github.com/adnanh/webhook). It's possible to install webhook as a native Linux service, please refer to that repository on details for installing that way. However, in this example we will be containerizing this webhook service.

- Install [Docker](https://docs.docker.com/get-docker/) on the host that will be running the branch protection web service.

Other container runtimes should work with this service as well.

## Usage

On the host where the port 9000 firewall rule is applied run the command below, making sure to substitute the values used in the [Create GitHub Webhook](#create-github-webhook) section.

```
docker run -d \
    -e WEBHOOK_SECRET=<webhook_secret> \
    -e GH_TOKEN=<github_pat> \
    -p 9000:9000 \
    ahromis/auto-branch-protect:latest
```

Once the service is running then create a new repo under your organization.

## Production Considerations

This example runs on the HTTP protocol. For production use this should be run using HTTPS. Enabling HTTPS for this web service can be accomplished by enabling HTTPS for the webhook project by following the [documentation](https://github.com/adnanh/webhook#using-https) or by using a TLS enabled load balancer in front of this service.

If enabling HTTPS by using the webhook project this repository will need to be forked, modified accordingly, and the container image will need to be rebuilt.

## References

- [webhook](https://github.com/adnanh/webhook)
- [GitHub APIv3](https://docs.github.com/en/rest)
- [Using Docker](https://docs.docker.com/)

