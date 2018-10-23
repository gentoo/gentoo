# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="AWS SDK for C++"
HOMEPAGE="https://aws.amazon.com/sdk-for-cpp/"
SRC_URI="https://github.com/aws/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MODULES=(
	access-management acm acm-pca alexaforbusiness
	apigateway application-autoscaling appstream appsync
	athena autoscaling autoscaling-plans AWSMigrationHub
	batch budgets ce cloud9 clouddirectory
	cloudformation cloudfront cloudhsm cloudhsmv2
	cloudsearch cloudsearchdomain cloudtrail codebuild
	codecommit codedeploy codepipeline codestar
	cognito-identity cognito-idp cognito-sync comprehend
	config connect cur datapipeline dax devicefarm
	directconnect discovery dms ds dynamodb
	dynamodbstreams ec2 ecr ecs eks elasticache
	elasticbeanstalk elasticfilesystem elasticloadbalancing
	elasticloadbalancingv2 elasticmapreduce elastictranscoder
	email es events firehose fms gamelift glacier
	glue greengrass guardduty health iam
	identity-management importexport inspector iot
	iot1click-devices iot1click-projects iotanalytics iot-data
	iot-jobs-data kinesis kinesisanalytics kinesisvideo
	kinesis-video-archived-media kinesis-video-media kms
	lambda lex lex-models lightsail logs
	machinelearning macie marketplacecommerceanalytics
	marketplace-entitlement mediaconvert medialive
	mediapackage mediastore mediastore-data mediatailor
	meteringmarketplace mobile mobileanalytics monitoring
	mq mturk-requester neptune opsworks opsworkscm
	organizations pi pinpoint polly pricing queues
	rds redshift rekognition resource-groups
	resourcegroupstaggingapi route53 route53domains s3
	s3-encryption sagemaker sagemaker-runtime sdb
	secretsmanager serverlessrepo servicecatalog
	servicediscovery shield sms snowball sns sqs ssm
	states storagegateway sts support swf text-to-speech
	transcribe transfer translate waf waf-regional
	workdocs workmail workspaces xray )

IUSE="asan http ssl static-libs rtti test ${MODULES[*]}"
REQUIRED_USE="test? ( http )"

DEPEND="
	dev-lang/python
	>=dev-util/cmake-3.0.0
	http? ( net-misc/curl )
	ssl? (
		dev-libs/openssl
		sys-libs/zlib ) "

src_configure() {
	local mybuildtargets="core"

	for module in ${MODULES[@]}; do
		if use ${module}; then
			mybuildtargets+=";${module}"
		fi
	done

	local mycmakeargs=(
		-DCPP_STANDARD=17
		-DENABLE_TESTING=$(usex test)
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DENABLE_ADDRESS_SANITIZER=$(usex asan)
		-DNO_ENCRYPTION=$(usex !ssl)
		-DNO_HTTP_CLIENT=$(usex !http)
		-DBUILD_ONLY="${mybuildtargets}"
	)
	cmake-utils_src_configure
}
