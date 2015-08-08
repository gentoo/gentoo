# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit versionator

DESCRIPTION="These command-line tools serve as the client interface to the Amazon EC2 web service"
HOMEPAGE="http://developer.amazonwebservices.com/connect/entry.jspa?externalID=368&categoryID=88"
SRC_URI="http://s3.amazonaws.com/ec2-downloads/${P}.zip"

LICENSE="Amazon
	|| ( Ruby GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_slot="2.0"

DEPEND="app-arch/unzip"
RDEPEND="dev-lang/ruby:${ruby_slot}[ssl]
	net-misc/rsync
	net-misc/curl"

src_prepare() {
	# Simplify the scripts to always run Ruby 20, since Gentoo supports
	# alternative implementations as well it is not guaranteed that ruby is ruby19.
	sed -i -e "\$s:^ruby:exec ruby${ruby_slot/./}:" bin/* || die 'Sed failed.'

	# Remove a left behind license file.
	rm lib/ec2/oem/LICENSE.txt || die 'Removal of LICENSE failed.'
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
