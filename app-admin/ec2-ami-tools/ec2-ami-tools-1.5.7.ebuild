# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

USE_RUBY="ruby22 ruby23"

inherit ruby-single versionator

DESCRIPTION="Command-line tools that serve as client interface to the Amazon EC2 web service"
HOMEPAGE="http://developer.amazonwebservices.com/connect/entry.jspa?externalID=368&categoryID=88"
SRC_URI="http://s3.amazonaws.com/ec2-downloads/${P}.zip"

LICENSE="Amazon
	|| ( Ruby GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
RDEPEND="
	${RUBY_DEPS}
	virtual/ruby-ssl
	net-misc/rsync
	net-misc/curl"

src_prepare() {
	# Remove a left behind license file.
	rm -f lib/ec2/oem/LICENSE.txt || die 'Removal of LICENSE failed.'

	eapply_user
}

src_install() {
	dobin bin/*

	insinto /usr
	doins -r lib

	insinto /etc/ec2/amitools
	doins etc/ec2/amitools/*

	dodir /etc/env.d
	echo "EC2_AMITOOL_HOME=/usr" >> "${T}"/99${PN} || die "Can't write environment variable."
	doenvd "${T}"/99${PN}
}

pkg_postinst() {
	ewarn "Remember to run \`env-update && source /etc/profile\` if you plan"
	ewarn "to use these tools in a shell before logging out (or restarting"
	ewarn "your login manager)."
}
