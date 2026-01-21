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
	[analytics]="athena;cleanrooms;cleanroomsml;datazone;entityresolution;finspace;finspace-data;firehose;forecast;forecastquery;glue;lakeformation;lookoutequipment;machinelearning;quicksight;repostspace;timestream-influxdb;amp;amplify;amplifybackend;amplifyuibuilder;omics;kafka;kafkaconnect;dsql;appflow;appintegrations;cloudsearch;cloudsearchdomain;databrew;dataexchange;datapipeline;kinesisanalytics;kinesisanalyticsv2;mwaa;mwaa-serverless;pi"
	[compute]="application-autoscaling;autoscaling;autoscaling-plans;batch;compute-optimizer;compute-optimizer-automation;ec2;ec2-instance-connect;ecr;ecr-public;ecs;eks;elasticbeanstalk;elasticmapreduce;emr-containers;emr-serverless;lambda;lightsail;outposts;simspaceweaver;elasticfilesystem;elasticloadbalancing;elasticloadbalancingv2;m2;s3outposts;imagebuilder;swf;apigateway;apigatewaymanagementapi;apigatewayv2;apprunner;appstream;appsync;eks-auth;states;workspaces-instances"
	[database]="docdb;docdb-elastic;dynamodb;dynamodbstreams;keyspaces;memorydb;neptune;neptune-graph;neptunedata;opensearch;opensearchserverless;rds;rds-data;redshift;redshift-data;redshift-serverless;sdb;timestream-influxdb;timestream-query;timestream-write;osis;clouddirectory;dax;elasticache;es;odb"
	[devops]="codeartifact;codebuild;codecatalyst;codecommit;codeconnections;codedeploy;codeguru-reviewer;codeguru-security;codepipeline;codestar-connections;codestar-notifications;devicefarm;gamelift;gameliftstreams;proton;artifact;b2bi;serverlessrepo;schemas;mturk-requester;cloud9;codeguruprofiler;keyspacesstreams"
	[iot]="greengrass;greengrassv2;groundstation;iot;iot-data;iot-jobs-data;iot-managed-integrations;iotanalytics;iotdeviceadvisor;iotevents;iotevents-data;iotfleetwise;iotsitewise;iotthingsgraph;iottwinmaker;iotwireless;iotsecuretunneling;panorama"
	[management]="account;appconfig;appconfigdata;applicationcostprofiler;application-insights;application-signals;budgets;billing;billingconductor;ce;cloudcontrol;cloudformation;cloudtrail;cloudtrail-data;controltower;cur;fms;license-manager;license-manager-linux-subscriptions;license-manager-user-subscriptions;marketplace-agreement;marketplace-catalog;marketplace-deployment;marketplace-entitlement;marketplace-reporting;marketplacecommerceanalytics;organizations;ram;resource-explorer-2;resource-groups;resourcegroupstaggingapi;savingsplans;service-quotas;servicecatalog;servicecatalog-appregistry;support;support-app;taxsettings;AWSMigrationHub;cost-optimization-hub;dlm;dms;drs;mgn;migration-hub-refactor-spaces;migrationhub-config;migrationhuborchestrator;migrationhubstrategy;launch-wizard;meteringmarketplace;supplychain;workspaces;workspaces-thin-client;workspaces-web;bcm-data-exports;bcm-pricing-calculator;controlcatalog;discovery;invoicing;partnercentral-selling;partnercentral-account;partnercentral-benefits;partnercentral-channel;ssm;ssm-contacts;ssm-guiconnect;ssm-incidents;ssm-quicksetup;ssm-sap;mpa"
	[media]="elastictranscoder;ivs;ivs-realtime;kinesis;kinesis-video-archived-media;kinesis-video-media;kinesis-video-signaling;kinesis-video-webrtc-storage;mediaconvert;mediatailor;voice-id;deadline;evs;ivschat;kinesisvideo;mediaconnect;medialive"
	[messaging]="chatbot;chime;chime-sdk-identity;chime-sdk-media-pipelines;chime-sdk-meetings;chime-sdk-messaging;chime-sdk-voice;connect;connect-contact-lens;connectcampaigns;connectcampaignsv2;connectcases;connectparticipant;customer-profiles;eventbridge;notifications;notificationscontacts;pinpoint;pinpoint-email;pinpoint-sms-voice-v2;pipes;rum;scheduler;sns;sqs;mailmanager;sms-voice;socialmessaging;wisdom;workmail;workmailmessageflow;mq;sesv2;email"
	[ml]="bedrock;bedrock-agent;bedrock-agent-runtime;bedrock-data-automation;bedrock-data-automation-runtime;bedrock-runtime;comprehend;comprehendmedical;frauddetector;personalize;personalize-events;personalize-runtime;rekognition;sagemaker;sagemaker-a2i-runtime;sagemaker-edge;sagemaker-featurestore-runtime;sagemaker-geospatial;sagemaker-metrics;sagemaker-runtime;sagemaker-runtime-http2;textract;transcribe;transcribestreaming;translate;lex;lex-models;lexv2-models;lexv2-runtime;qapps;qbusiness;medical-imaging;kendra;kendra-ranking;polly;qconnect"
	[monitor]="config;devops-guru;health;inspector;inspector-scan;inspector2;internetmonitor;logs;monitoring;observabilityadmin;resiliencehub;security-ir;synthetics;trustedadvisor;wellarchitected;xray;fis;grafana;healthlake;oam;aiops;appfabric;evidently"
	[networking]="appmesh;cloudfront;cloudfront-keyvaluestore;directconnect;globalaccelerator;location;network-firewall;networkflowmonitor;networkmanager;networkmonitor;route53;route53-recovery-cluster;route53-recovery-control-config;route53-recovery-readiness;route53domains;route53profiles;route53resolver;route53globalresolver;vpc-lattice;geo-maps;geo-places;geo-routes;tnb;arc-zonal-shift;servicediscovery"
	[security]="accessanalyzer;acm;acm-pca;codeguru-security;guardduty;iam;macie2;payment-cryptography;payment-cryptography-data;rolesanywhere;secretsmanager;securityhub;securitylake;shield;signer;verifiedpermissions;waf;waf-regional;wafv2;auditmanager;cloudhsm;cloudhsmv2;detective;directory-service-data;pca-connector-ad;pca-connector-scep;pcs;sso;sso-admin;signin"
	[storage]="backup;backup-gateway;datasync;ebs;fsx;glacier;mediapackage;mediapackage-vod;mediapackagev2;mediastore;mediastore-data;s3;s3-crt;snow-device-management;snowball;storagegateway;workdocs;awstransfer;importexport;rbin;s3tables;backupsearch;s3control"
	[uncategorized]="ds;evs;braket;freetier;managedblockchain;managedblockchain-query;nova-act"
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
