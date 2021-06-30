# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TEDDY
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="Send UTF-8 HTML and text email using templates"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Mail-Builder-1.120.0
	dev-perl/Email-Sender
	dev-perl/Email-Valid
	dev-perl/Config-Any
	dev-perl/Config-General
	dev-perl/Exception-Died
	>=dev-perl/MailTools-2.40.0
	dev-perl/Email-MessageID
	dev-perl/MIME-tools
	dev-perl/HTML-Template
	dev-perl/Template-Toolkit
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"
