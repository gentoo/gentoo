# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit cmake python-single-r1

DESCRIPTION="AWS SDK for C++"
HOMEPAGE="https://aws.amazon.com/sdk-for-cpp/"
SRC_URI="https://github.com/aws/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MODULES=(
	access-management apigateway appconfig backup batch budgets chime cloud-desktop cloud-dev cloud-media
	cloud-mobile cloudformation cloudfront cloudhsm cloudsearch cloudwatch cognito config dlm ebs ec2 ecr ecs
	eks elasticache elasticbeanstalk elastic-inference elasticloadbalancing elasticmapreduce email es events
	forecast frauddetector fsx globalaccelerator iot kendra kinesis kms lambda lex license-manager lightsail
	lookoutvision machinelearning macie managedblockchain marketplace mwaa networkmanager opsworks
	organizations other outposts personalize polly qldb queues rds rekognition resource-groups route53 s3
	sagemaker secretsmanager securityhub serverlessrepo shield sns sqs textract timestream transcribe
	translate waf wellarchitected
)

IUSE="+http libressl pulseaudio +rtti +ssl static-libs test unity-build ${MODULES[*]}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="
	http? ( net-misc/curl:= )
	pulseaudio? ( media-sound/pulseaudio )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	>=dev-libs/aws-c-common-0.5.2:=[static-libs=]
	>=dev-libs/aws-c-event-stream-0.2.7:=[static-libs=]
	>=dev-libs/aws-checksums-0.1.10:=[static-libs=]
	sys-libs/zlib
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

PATCHES=(
	"${FILESDIR}"/${PN}-upgrade_android-build_build_and_test_android_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_binary-release-pipeline_lambda_publish_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_CI_ConstructReleaseDoc_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_CI_ExtractBuildArgs_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_CI_handle_release_notification_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_CI_move_release_doc_to_models_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_doc_crosslinks_generate_cross_link_data_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_scripts_build_3rdparty_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_scripts_build_example_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_scripts_dummy_web_server_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_scripts_endpoints_checker_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_scripts_gather_3rdparty_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_scripts_generate_sdks_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_scripts_renew_license_py-3.9.patch
	"${FILESDIR}"/${PN}-upgrade_scripts_run_integration_tests_py-3.9.patch
	"${FILESDIR}"/${PN}-1.8.105-remove_Werror_from_FLAGS.patch
	"${FILESDIR}"/${P}-disable_http_testing.patch
)

src_configure() {
	local mybuildtargets="core"

	for module in ${MODULES[@]}; do
		if use ${module}; then
			if [ "${module}" = "access-management" ] ; then
				mybuildtargets+=";${module};accessanalyzer;acm;acm-pca;dataexchange;iam"
				mybuildtargets+=";identity-management;identitystore;ram;sso;sso-admin;sso-oidc;sts"
			elif [ "${module}" = "apigateway" ] ; then
				mybuildtargets+=";${module};apigatewaymanagementapi;apigatewayv2"
			elif [ "${module}" = "budgets" ] ; then
				mybuildtargets+=";${module};ce;cur"
			elif [ "${module}" = "cloud-desktop" ] ; then
				mybuildtargets+=";appstream;workdocs;worklink;workmail;workmailmessageflow;workspaces"
			elif [ "${module}" = "cloud-dev" ] ; then
				mybuildtargets+=";cloud9;codeartifact;codebuild;codecommit;codedeploy;codeguruprofiler"
				mybuildtargets+=";codeguru-reviewer;codepipeline;codestar;codestar-connections"
				mybuildtargets+=";codestar-notifications;honeycode;xray"
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
				mybuildtargets+=";application-insights;appmesh;auditmanager;cloudtrail;compute-optimizer"
				mybuildtargets+=";detective;devops-guru;guardduty;health;inspector;logs;monitoring;synthetics"
			elif [ "${module}" = "cognito" ] ; then
				mybuildtargets+=";cognito-identity;cognito-idp;cognito-sync"
			elif [ "${module}" = "dynamodb" ] ; then
				mybuildtargets+=";${module};dax;dynamodbstreams"
			elif [ "${module}" = "ec2" ] ; then
				mybuildtargets+=";${module};autoscaling;autoscaling-plans;application-autoscaling"
				mybuildtargets+=";ec2-instance-connect;elasticfilesystem;imagebuilder;savingsplans"
			elif [ "${module}" = "ecr" ] ; then
				mybuildtargets+=";${module};ecr-public"
			elif [ "${module}" = "eks" ] ; then
				mybuildtargets+=";${module};emr-containers"
			elif [ "${module}" = "elasticloadbalancing" ] ; then
				mybuildtargets+=";${module};elasticloadbalancingv2"
			elif [ "${module}" = "email" ] ; then
				mybuildtargets+=";${module};sesv2"
			elif [ "${module}" = "events" ] ; then
				mybuildtargets+=";${module};eventbridge"
			elif [ "${module}" = "forecast" ] ; then
				mybuildtargets+=";${module};forecastquery"
			elif [ "${module}" = "iot" ] ; then
				mybuildtargets+=";${module};greengrass;greengrassv2;iot1click-devices;iot1click-projects;iotanalytics"
				mybuildtargets+=";iot-data;iotdeviceadvisor;iotevents;iotfleethub;iotevents-data;iot-jobs-data"
				mybuildtargets+=";iotsecuretunneling;iotsitewise;iotthingsgraph;iotwireless"
			elif [ "${module}" = "kinesis" ] ; then
				mybuildtargets+=";${module};firehose;ivs;kinesisanalytics;kinesisanalyticsv2"
				mybuildtargets+=";kinesisvideo;kinesis-video-archived-media;kinesis-video-media"
				mybuildtargets+=";kinesis-video-signaling"
			elif [ "${module}" = "lex" ] ; then
				mybuildtargets+=";${module};lex-models;lexv2-models;lexv2-runtime"
			elif [ "${module}" = "macie" ] ; then
				mybuildtargets+=";${module};macie2"
			elif [ "${module}" = "marketplace" ] ; then
				mybuildtargets+=";marketplacecommerceanalytics;marketplace-catalog"
				mybuildtargets+=";marketplace-entitlement;meteringmarketplace;pricing"
				mybuildtargets+=";servicecatalog-appregistry"
			elif [ "${module}" = "opsworks" ] ; then
				mybuildtargets+=";${module};opsworkscm"
			elif [ "${module}" = "other" ] ; then
				mybuildtargets+=";AWSMigrationHub;alexaforbusiness;appflow;appintegrations;braket;clouddirectory"
				mybuildtargets+=";comprehend;comprehendmedical;connect;connect-contact-lens"
				mybuildtargets+=";connectparticipant;customer-profiles;datapipeline;databrew;datasync"
				mybuildtargets+=";directconnect;discovery;dms;docdb;ds;dynamodb;gamelift;glue"
				mybuildtargets+=";groundstation;healthlake;importexport;kafka;lakeformation"
				mybuildtargets+=";migrationhub-config;mq;mturk-requester;neptune;quicksight;redshift"
				mybuildtargets+=";robomaker;sdb;schemas;service-quotas;servicecatalog;servicediscovery"
				mybuildtargets+=";signer;sms;snowball;ssm;states;storagegateway;support;swf"
			elif [ "${module}" = "outposts" ] ; then
				mybuildtargets+=";${module};s3outposts"
			elif [ "${module}" = "personalize" ] ; then
				mybuildtargets+=";${module};personalize-events;personalize-runtime"
			elif [ "${module}" = "polly" ] ; then
				mybuildtargets+=";${module};text-to-speech"
			elif [ "${module}" = "qldb" ] ; then
				mybuildtargets+=";${module};qldb-session"
			elif [ "${module}" = "rds" ] ; then
				mybuildtargets+=";${module};pi;rds-data"
			elif [ "${module}" = "resource-groups" ] ; then
				mybuildtargets+=";${module};resourcegroupstaggingapi"
			elif [ "${module}" = "route53" ] ; then
				mybuildtargets+=";${module};route53domains;route53resolver"
			elif [ "${module}" = "s3" ] ; then
				mybuildtargets+=";${module};athena;awstransfer;glacier;s3-encryption;s3control;transfer"
			elif [ "${module}" = "sagemaker" ] ; then
				mybuildtargets+=";${module};sagemaker-a2i-runtime;sagemaker-edge"
				mybuildtargets+=";sagemaker-featurestore-runtime;sagemaker-runtime"
			elif [ "${module}" = "timestream" ] ; then
				mybuildtargets+=";timestream-query;timestream-write"
			elif [ "${module}" = "transcribe" ] ; then
				mybuildtargets+=";${module};transcribestreaming"
			elif [ "${module}" = "waf" ] ; then
				mybuildtargets+=";${module};fms;network-firewall;waf-regional;wafv2"
			else
				mybuildtargets+=";${module}"
			fi
		fi
	done

	local mycmakeargs=(
		-DAUTORUN_UNIT_TESTS=$(usex test)
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

	if use test; then
		# (#759802) Due to network sandboxing of portage, internet connectivity
		# tests will always fail. If you need a USE flag, because you want/need
		# to perform these tests manually, please open a bug report for it.
		mycmakeargs+=(
			-DENABLE_HTTP_CLIENT_TESTING=OFF
		)
	fi

	cmake_src_configure
}
