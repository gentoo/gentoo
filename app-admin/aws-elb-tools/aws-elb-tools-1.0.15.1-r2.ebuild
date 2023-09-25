# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Serves as the client interface to the Elastic Load Balancing web service"
HOMEPAGE="https://aws.amazon.com/developertools/Amazon-EC2/2536"
SRC_URI="mirror://sabayon/${CATEGORY}/ElasticLoadBalancing-${PV}.zip"
S="${WORKDIR}/ElasticLoadBalancing-${PV}"

LICENSE="Amazon"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="mirror"

BDEPEND="app-arch/unzip"
RDEPEND="virtual/jre"

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
		AWS_ELB_HOME=/opt/${PN}
		PATH=/opt/${PN}/bin
		ROOTPATH=/opt/${PN}/bin
	EOF
	doenvd "${T}"/99${PN}

	dodoc THIRDPARTYLICENSE.TXT
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
