# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AWS SDK for C++"
HOMEPAGE="https://github.com/aws/aws-sdk-cpp"
SRC_URI="https://github.com/aws/aws-sdk-cpp/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# BUILD_ONLY lists
declare -g -A AWS_GROUPS=(
	[analytics]="amp;amplify;amplifybackend;amplifyuibuilder;appflow;appintegrations;athena;cleanrooms;cleanroomsml;cloudsearch;cloudsearchdomain;databrew;dataexchange;datapipeline;datazone;dsql;entityresolution;finspace;finspace-data;firehose;forecast;forecastquery;glue;kafka;kafkaconnect;kinesisanalytics;kinesisanalyticsv2;lakeformation;lookoutequipment;machinelearning;mwaa;mwaa-serverless;omics;pi;quicksight;repostspace;timestream-influxdb"
	[compute]="apigateway;apigatewaymanagementapi;apigatewayv2;application-autoscaling;apprunner;appstream;appsync;autoscaling;autoscaling-plans;batch;compute-optimizer;compute-optimizer-automation;ec2;ec2-instance-connect;ecr;ecr-public;ecs;eks;eks-auth;elasticbeanstalk;elasticfilesystem;elasticloadbalancing;elasticloadbalancingv2;elasticmapreduce;emr-containers;emr-serverless;imagebuilder;lambda;lightsail;m2;outposts;s3outposts;simspaceweaver;states;swf;workspaces-instances"
	[database]="clouddirectory;dax;docdb;docdb-elastic;dynamodb;dynamodbstreams;elasticache;es;keyspaces;memorydb;neptune;neptunedata;neptune-graph;odb;opensearch;opensearchserverless;osis;rds;rds-data;redshift;redshift-data;redshift-serverless;sdb;timestream-influxdb;timestream-query;timestream-write"
	[devops]="artifact;b2bi;cloud9;codeartifact;codebuild;codecatalyst;codecommit;codeconnections;codedeploy;codeguruprofiler;codeguru-reviewer;codeguru-security;codepipeline;codestar-connections;codestar-notifications;devicefarm;gamelift;gameliftstreams;keyspacesstreams;mturk-requester;proton;schemas;serverlessrepo"
	[iot]="greengrass;greengrassv2;groundstation;iot;iot-data;iotdeviceadvisor;iotevents;iotevents-data;iotfleetwise;iot-jobs-data;iot-managed-integrations;iotsecuretunneling;iotsitewise;iotthingsgraph;iottwinmaker;iotwireless;panorama"
	[management]="account;appconfig;appconfigdata;applicationcostprofiler;application-insights;application-signals;AWSMigrationHub;bcm-data-exports;bcm-pricing-calculator;billing;billingconductor;budgets;ce;cloudcontrol;cloudformation;cloudtrail;cloudtrail-data;controlcatalog;controltower;cost-optimization-hub;cur;discovery;dlm;dms;drs;fms;invoicing;launch-wizard;license-manager;license-manager-linux-subscriptions;license-manager-user-subscriptions;marketplace-agreement;marketplace-catalog;marketplacecommerceanalytics;marketplace-deployment;marketplace-entitlement;marketplace-reporting;meteringmarketplace;mgn;migrationhub-config;migrationhuborchestrator;migration-hub-refactor-spaces;migrationhubstrategy;mpa;organizations;partnercentral-account;partnercentral-benefits;partnercentral-channel;partnercentral-selling;ram;resource-explorer-2;resource-groups;resourcegroupstaggingapi;savingsplans;servicecatalog;servicecatalog-appregistry;service-quotas;ssm;ssm-contacts;ssm-guiconnect;ssm-incidents;ssm-quicksetup;ssm-sap;supplychain;support;support-app;taxsettings;workspaces;workspaces-thin-client;workspaces-web"
	[media]="deadline;elementalinference;evs;ivs;ivschat;ivs-realtime;kinesis;kinesisvideo;kinesis-video-archived-media;kinesis-video-media;kinesis-video-signaling;kinesis-video-webrtc-storage;mediaconnect;mediaconvert;medialive;mediatailor;voice-id"
	[messaging]="chatbot;chime;chime-sdk-identity;chime-sdk-media-pipelines;chime-sdk-meetings;chime-sdk-messaging;chime-sdk-voice;connect;connectcampaigns;connectcampaignsv2;connectcases;connect-contact-lens;connectparticipant;customer-profiles;email;eventbridge;mailmanager;mq;notifications;notificationscontacts;pinpoint;pinpoint-email;pinpoint-sms-voice-v2;pipes;rum;scheduler;sesv2;sms-voice;sns;socialmessaging;sqs;wickr;wisdom;workmail;workmailmessageflow"
	[ml]="bedrock;bedrock-agent;bedrock-agent-runtime;bedrock-data-automation;bedrock-data-automation-runtime;bedrock-runtime;comprehend;comprehendmedical;frauddetector;kendra;kendra-ranking;lex;lex-models;lexv2-models;lexv2-runtime;medical-imaging;personalize;personalize-events;personalize-runtime;polly;qapps;qbusiness;qconnect;rekognition;sagemaker;sagemaker-a2i-runtime;sagemaker-edge;sagemaker-featurestore-runtime;sagemaker-geospatial;sagemaker-metrics;sagemaker-runtime;sagemaker-runtime-http2;textract;transcribe;transcribestreaming;translate"
	[monitor]="aiops;appfabric;config;devops-guru;fis;grafana;health;healthlake;inspector;inspector2;inspector-scan;internetmonitor;logs;monitoring;oam;observabilityadmin;resiliencehub;security-ir;synthetics;trustedadvisor;wellarchitected;xray"
	[networking]="appmesh;arc-zonal-shift;cloudfront;cloudfront-keyvaluestore;directconnect;geo-maps;geo-places;geo-routes;globalaccelerator;location;network-firewall;networkflowmonitor;networkmanager;networkmonitor;route53;route53domains;route53globalresolver;route53profiles;route53-recovery-cluster;route53-recovery-control-config;route53-recovery-readiness;route53resolver;servicediscovery;tnb;vpc-lattice"
	[security]="accessanalyzer;acm;acm-pca;auditmanager;cloudhsm;cloudhsmv2;codeguru-security;detective;directory-service-data;guardduty;iam;macie2;payment-cryptography;payment-cryptography-data;pca-connector-ad;pca-connector-scep;pcs;rolesanywhere;secretsmanager;securityhub;securitylake;shield;signer;signer-data;signin;sso;sso-admin;verifiedpermissions;waf;waf-regional;wafv2"
	[storage]="awstransfer;backup;backup-gateway;backupsearch;datasync;ebs;fsx;glacier;importexport;mediapackage;mediapackagev2;mediapackage-vod;mediastore;mediastore-data;rbin;s3;s3control;s3-crt;s3tables;snowball;snow-device-management;storagegateway;workdocs"
	[uncategorized]="braket;connecthealth;ds;evs;freetier;managedblockchain;managedblockchain-query;nova-act"
)

IUSE="${!AWS_GROUPS[*]}"

DEPEND="dev-cpp/aws-crt-cpp:=
	dev-libs/aws-c-auth:=
	dev-libs/aws-c-common:=
	dev-libs/aws-c-compression:=
	dev-libs/aws-c-event-stream:=
	dev-libs/aws-c-http:=
	dev-libs/aws-c-io:=
	dev-libs/aws-c-mqtt:=
	dev-libs/aws-c-s3:=
	dev-libs/aws-c-sdkutils:=
	dev-libs/aws-checksums:=
	net-misc/curl:=
	virtual/zlib:="
RDEPEND="${DEPEND}"
BDEPEND="dev-libs/aws-c-common"

src_configure() {
	local mybuildtargets="core;kms;identity-management;sts;cognito-identity;cognito-idp;cognito-sync;identitystore;sso-oidc;events;pricing"

	local g
	for g in "${!AWS_GROUPS[@]}"; do
		if use "${g}"; then
			mybuildtargets+=";${AWS_GROUPS[$g]}"
		fi
	done

	local mycmakeargs=(
		-DLEGACY_BUILD=ON
		-DBUILD_DEPS=OFF # disable embedded 3rd-party repositories.
		-DBUILD_ONLY="${mybuildtargets}"
	)

	cmake_src_configure
}
