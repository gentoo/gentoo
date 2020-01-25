# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit cmake python-single-r1

DESCRIPTION="AWS SDK for C++"
HOMEPAGE="https://aws.amazon.com/sdk-for-cpp/"
SRC_URI="https://github.com/aws/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MODULES=(
	access-management apigateway backup batch budgets chime cloud-desktop cloud-dev cloud-media cloud-mobile
	cloudformation cloudfront cloudhsm cloudsearch cloudwatch cognito config dlm ec2 ecr ecs eks elasticache
	elasticbeanstalk elasticloadbalancing elasticmapreduce email es events fsx globalaccelerator iot kinesis kms
	lambda lex license-manager lightsail machinelearning macie managedblockchain marketplace opsworks organizations
	other personalize polly queues rds rekognition resource-groups route53 s3 sagemaker secretsmanager securityhub
	serverlessrepo shield sns sqs textract transcribe translate waf
)

IUSE="+http libressl +rtti +ssl static-libs test unity-build ${MODULES[*]}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="
	http? ( net-misc/curl:= )
	polly? ( media-sound/pulseaudio )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	dev-libs/aws-c-common
	dev-libs/aws-checksums
	dev-libs/aws-c-event-stream
	sys-libs/zlib
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

src_configure() {
	local mybuildtargets="core"

	for module in ${MODULES[@]}; do
		if use ${module}; then
			if [ "${module}" = "access-management" ] ; then
				mybuildtargets+=";${module};acm;acm-pca;iam;identity-management;ram;sts"
			elif [ "${module}" = "apigateway" ] ; then
				mybuildtargets+=";${module};apigatewaymanagementapi;apigatewayv2"
			elif [ "${module}" = "budgets" ] ; then
				mybuildtargets+=";${module};ce;cur"
			elif [ "${module}" = "cloud-desktop" ] ; then
				mybuildtargets+=";appstream;workdocs;worklink;workmail;workspaces"
			elif [ "${module}" = "cloud-dev" ] ; then
				mybuildtargets+=";cloud9;codebuild;codecommit;codedeploy;codepipeline;codestar;xray"
				if ! use "queues"; then
					mybuildtargets+=";queues"
				fi
			elif [ "${module}" = "cloud-media" ] ; then
				mybuildtargets+=";elastictranscoder;mediaconnect;mediaconvert;medialive;mediapackage"
				mybuildtargets+=";mediapackage-vod;mediastore;mediastore-data;mediatailor"
			elif [ "${module}" = "cloud-mobile" ] ; then
				mybuildtargets+=";amplify;appsync;devicefarm;mobile;mobileanalytics;pinpoint"
				mybuildtargets+=";pinpoint-email;sms-voice"
				if ! use "sns"; then
					mybuildtargets+=";sns"
				fi
			elif [ "${module}" = "cloudhsm" ] ; then
				mybuildtargets+=";${module};cloudhsmv2"
			elif [ "${module}" = "cloudsearch" ] ; then
				mybuildtargets+=";${module};cloudsearchdomain"
			elif [ "${module}" = "cloudwatch" ] ; then
				mybuildtargets+=";application-insights;appmesh;cloudtrail;guardduty;health;inspector"
				mybuildtargets+=";logs;monitoring"
			elif [ "${module}" = "cognito" ] ; then
				mybuildtargets+=";cognito-identity;cognito-idp;cognito-sync"
			elif [ "${module}" = "dynamodb" ] ; then
				mybuildtargets+=";${module};dax;dynamodbstreams"
			elif [ "${module}" = "ec2" ] ; then
				mybuildtargets+=";${module};autoscaling;autoscaling-plans;application-autoscaling"
				mybuildtargets+=";ec2-instance-connect;elasticfilesystem"
			elif [ "${module}" = "elasticloadbalancing" ] ; then
				mybuildtargets+=";${module};elasticloadbalancingv2"
			elif [ "${module}" = "events" ] ; then
				mybuildtargets+=";${module};eventbridge"
			elif [ "${module}" = "iot" ] ; then
				mybuildtargets+=";${module};greengrass;iot1click-devices;iot1click-projects"
				mybuildtargets+=";iotanalytics;iot-data;iotevents;iotevents-data;iot-jobs-data"
				mybuildtargets+=";iotthingsgraph"
			elif [ "${module}" = "kinesis" ] ; then
				mybuildtargets+=";${module};firehose;kinesisanalytics;kinesisanalyticsv2;kinesisvideo"
				mybuildtargets+=";kinesis-video-archived-media;kinesis-video-media"
			elif [ "${module}" = "lex" ] ; then
				mybuildtargets+=";${module};lex-models"
			elif [ "${module}" = "marketplace" ] ; then
				mybuildtargets+=";marketplacecommerceanalytics;marketplace-entitlement"
				mybuildtargets+=";meteringmarketplace;pricing"
			elif [ "${module}" = "opsworks" ] ; then
				mybuildtargets+=";${module};opsworkscm"
			elif [ "${module}" = "other" ] ; then
				mybuildtargets+=";AWSMigrationHub;alexaforbusiness;clouddirectory;comprehend"
				mybuildtargets+=";comprehendmedical;connect;datapipeline;datasync;directconnect"
				mybuildtargets+=";discovery;dms;docdb;ds;dynamodb;gamelift;glue;groundstation"
				mybuildtargets+=";importexport;kafka;lakeformation;mq;mturk-requester;neptune"
				mybuildtargets+=";quicksight;redshift;robomaker;sdb;service-quotas;servicecatalog"
				mybuildtargets+=";servicediscovery;signer;sms;snowball;ssm;states;storagegateway"
				mybuildtargets+=";support;swf"
			elif [ "${module}" = "personalize" ] ; then
				mybuildtargets+=";${module};personalize-events;personalize-runtime"
			elif [ "${module}" = "polly" ] ; then
				mybuildtargets+=";${module};text-to-speech"
			elif [ "${module}" = "rds" ] ; then
				mybuildtargets+=";${module};pi;rds-data"
			elif [ "${module}" = "resource-groups" ] ; then
				mybuildtargets+=";${module};resourcegroupstaggingapi"
			elif [ "${module}" = "route53" ] ; then
				mybuildtargets+=";${module};route53domains;route53resolver"
			elif [ "${module}" = "s3" ] ; then
				mybuildtargets+=";${module};athena;awstransfer;glacier;s3-encryption;s3control;transfer"
			elif [ "${module}" = "sagemaker" ] ; then
				mybuildtargets+=";${module};sagemaker-runtime"
			elif [ "${module}" = "transcribe" ] ; then
				mybuildtargets+=";${module};transcribestreaming"
			elif [ "${module}" = "waf" ] ; then
				mybuildtargets+=";${module};fms;waf-regional"
			else
				mybuildtargets+=";${module}"
			fi
		fi
	done

	local mycmakeargs=(
		-DBUILD_DEPS=NO
		-DBUILD_ONLY="${mybuildtargets}"
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DCPP_STANDARD=17
		-DENABLE_RTTI=$(usex rtti)
		-DENABLE_TESTING=$(usex test)
		-DENABLE_UNITY_BUILD=$(usex unity-build)
		-DNO_ENCRYPTION=$(usex !ssl)
		-DNO_HTTP_CLIENT=$(usex !http)
	)
	cmake_src_configure
}
