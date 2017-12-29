# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The Command Line Interface for the AWS Identity and Access Management Service"
HOMEPAGE="http://aws.amazon.com/developertools/AWS-Identity-and-Access-Management/4143"
SRC_URI="mirror://sabayon/${CATEGORY}/IAMCli-${PV}.zip"

LICENSE="Amazon"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="app-arch/unzip"
RDEPEND="virtual/jre"

S="${WORKDIR}/IAMCli-${PV}"

src_prepare() {
	default
	find . -name '*.cmd' -delete || die
}

src_install() {
	insinto /opt/${PN}/lib
	doins -r lib/.

	exeinto /opt/${PN}/bin
	doexe bin/*

	cat > "${T}"/99${PN} <<- EOF || die
		AWS_IAM_HOME=/opt/${PN}
		PATH=/opt/${PN}/bin
		ROOTPATH=/opt/${PN}/bin
	EOF
	doenvd "${T}"/99${PN}

	dodoc LICENSE.txt
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
