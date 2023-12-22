CDK_VERSION=2.116.0
export AWS_PROFILE=kblaz-root
AWS_DEFAULT_REGION=eu-central-1
AWS_REGION=eu-central-1
AWS_ACCOUNT_ID=535008103911
BUCKET_NAME=cdk-app-$$(echo $$RANDOM)-$(AWS_PROFILE)-$(AWS_DEFAULT_REGION)



aws-auth:
	aws-vault login $(AWS_PROFILE)

init-s3:
	aws s3api create-bucket  \
 			--bucket $(BUCKET_NAME)  \
 			--region $(AWS_REGION) \
 			--create-bucket-configuration LocationConstraint=$(AWS_REGION)

bootstrap:
	npx cdk@$(CDK_VERSION) bootstrap  \
		--profile $(AWS_PROFILE) aws://$(AWS_ACCOUNT_ID)/$(AWS_REGION)

init:
	if [ ! -d "app" ]; then mkdir app; fi && \
	cd app && \
	npx cdk@$(CDK_VERSION) init app --language=go

synth:
	cd app && \
	npx cdk@$(CDK_VERSION) synth

deploy:
	cd app && \
	npx cdk@$(CDK_VERSION) deploy --profile $(AWS_PROFILE) --require-approval never

get_packages:
	cd app && \
	go get