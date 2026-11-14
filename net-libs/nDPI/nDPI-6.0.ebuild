# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edo

DESCRIPTION="Open Source Deep Packet Inspection Software Toolkit"
HOMEPAGE="https://www.ntop.org/"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ntop/${PN}"
	inherit git-r3
else
	SRC_URI="https://github.com/ntop/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-3+"
SLOT="0/$(ver_cut 1)"

DEPEND="dev-libs/json-c:=
	dev-libs/libgcrypt:=
	dev-libs/libgpg-error
	net-libs/libpcap"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# "local" here means "local to the system", and hence means
	# system copy, not the bundled one.
	econf --with-local-libgcrypt
}

src_test() {
	local -x LD_LIBRARY_PATH="${S}/src/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

	pushd tests || die

	edo ./do.sh
	edo ./do-unit.sh

	popd || die
}
