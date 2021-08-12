# Containers in AWS

## Work environment

Pull the repository to your local machine. The repository's folder *terraform* will map to the Docker's volume called *local-git*.

Prepare a credentials file with the following structure

```bash
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=
```

and fill out the values after the credentials for the AWS user are generated.

Run the following command

```bash
docker run -itd --name terraformer --env-file "aws/credentials" --volume PATH_TO_REPOSITORY\iac-aws-ecs-eks\terraform:/local-git markokole/terraformer:1.0.3
```

This will start the container. Now step into the container with the following command:

```bash
docker exec -it terraformer /bin/sh
```
