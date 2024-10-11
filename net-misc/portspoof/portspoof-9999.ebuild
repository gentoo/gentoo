# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Return SYN+ACK for every port connection attempt"
HOMEPAGE="http://portspoof.org/"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://github.com/drk1wi/${PN}.git"
else
	SRC_URI="https://github.com/drk1wi/portspoof/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

src_prepare() {
	default
	if [[ ${PV} == *9999* ]] ; then
		mv configure.in configure.ac || die
		eautoreconf
	fi
	sed -i \
	's#/usr/local/bin/portspoof -D -c /usr/local/etc/portspoof.conf -s /usr/local/etc/portspoof_signatures#/usr/bin/portspoof -D -c /etc/portspoof.conf -s /etc/portspoof_signatures#'\
	 system_files/init.d/portspoof.sh || die
	sed -i '/#include <sys\/sysctl.h>/d' src/connection.h || die
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/861698
	# https://github.com/drk1wi/portspoof/issues/48
	#
	# Do not trust it with LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	default
}

src_install() {
	default_src_install
	newsbin system_files/init.d/portspoof.sh portspoof-runner
}
