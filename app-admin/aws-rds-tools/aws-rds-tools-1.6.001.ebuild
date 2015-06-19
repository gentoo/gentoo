# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/aws-rds-tools/aws-rds-tools-1.6.001.ebuild,v 1.1 2012/02/16 10:27:14 lxnay Exp $

EAPI="2"

DESCRIPTION="The Command Line Toolkit for the Amazon Relational Database Service"
HOMEPAGE="http://aws.amazon.com/developertools/2928"
SRC_URI="mirror://sabayon/${CATEGORY}/RDSCli-${PV}.zip"

S="${WORKDIR}/RDSCli-${PV}"

LICENSE="Amazon"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="app-arch/unzip"
RDEPEND="virtual/jre"
RESTRICT="mirror"

src_unpack() {
	unpack ${A}
	cd "$S"
	find . -name '*.cmd' -delete || die
}

src_install() {
	dodir /opt/${PN}
	insinto /opt/${PN}/lib
	doins -r "${S}"/lib/*
	exeinto /opt/${PN}/bin
	doexe "${S}"/bin/*

	dodir /etc/env.d
	cat - > "${T}"/99${PN} <<EOF
AWS_RDS_HOME=/opt/${PN}
PATH=/opt/${PN}/bin
ROOTPATH=/opt/${PN}/bin
EOF
	doenvd "${T}"/99${PN}

	dodoc "THIRDPARTYLICENSE.TXT"
}

pkg_postinst() {
	ewarn "Remember to run: env-update && source /etc/profile if you plan"
	ewarn "to use these tools in a shell before logging out (or restarting"
	ewarn "your login manager)"
	elog
	elog "You need to put the following in your ~/.bashrc replacing the"
	elog "values with the full path to your AWS credentials file."
	elog
	elog "  export AWS_CREDENTIAL_FILE=/path/and_filename_of_credential_file"
	elog
	elog "It should contains two lines: the first line lists the AWS Account's"
	elog "AWS Access Key ID, and the second line lists the AWS Account's"
	elog "Secret Access Key. For example:"
	elog
	elog "  AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE"
	elog "  AWSSecretKey=wJalrXUtnFEMI/K7MDENG/bPxRfiCYzEXAMPLEKEY"
}
