# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="return SYN+ACK for every port connection attempt"
HOMEPAGE="http://portspoof.org/"
LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://github.com/drk1wi/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/drk1wi/portspoof/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		eautoreconf
	fi
	sed -i \
	's#/usr/local/bin/portspoof -D -c /usr/local/etc/portspoof.conf -s /usr/local/etc/portspoof_signatures#/usr/bin/portspoof -D -c /etc/portspoof.conf -s /etc/portspoof_signatures#'\
	 system_files/init.d/portspoof.sh
}

src_install() {
	default_src_install
	newsbin system_files/init.d/portspoof.sh portspoof-runner
}
