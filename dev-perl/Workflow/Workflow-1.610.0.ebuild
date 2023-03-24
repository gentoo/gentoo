# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="JONASBN"
DIST_VERSION="1.61"

inherit perl-module

DESCRIPTION="Data blackboard for Workflows, Actions, Conditions and Validators"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-perl/DateTime-Format-Strptime-1.790.0
	>=dev-perl/Class-Accessor-0.510.0
	>=dev-perl/XML-Simple-2.250.0
	dev-perl/Readonly
	dev-perl/File-Slurp
	>=dev-perl/Class-Factory-1.60.0
	dev-perl/Data-UUID
	dev-perl/Pod-Coverage-TrustPod
	dev-perl/DBI
	>=dev-perl/Log-Log4perl-1.540.0
	>=dev-perl/Exception-Class-1.450.0
	>=dev-perl/DateTime-1.540.0"

BDEPEND="${RDEPEND}
	test? (
		>=dev-perl/DBD-Mock-1.59
		dev-perl/Mock-MonkeyPatch
		>=dev-perl/Test-Pod-1.510.0
		dev-perl/Test-Exception
		>=dev-perl/Test-Kwalitee-1.280.0
		>=dev-perl/Test-Pod-Coverage-1.100.0
		dev-perl/List-MoreUtils
	)"
