# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit eutils autotools-utils

DESCRIPTION="Instant terminal sharing"
HOMEPAGE="http://tmate.io/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug static-libs"

UPSTREAM_VER=0
[[ -n ${UPSTREAM_VER} ]] && \
	UPSTREAM_PATCHSET_URI="https://dev.gentoo.org/~dlan/distfiles/${P}-upstream-patches-${UPSTREAM_VER}.tar.xz"
SRC_URI="https://github.com/tmate-io/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${UPSTREAM_PATCHSET_URI}"

RDEPEND="
	sys-libs/zlib[static-libs?]
	sys-libs/libutempter[static-libs?]
	dev-libs/openssl[static-libs?]
	dev-libs/libevent[static-libs?]
	dev-libs/msgpack[static-libs?]
	>=net-libs/libssh-0.6.0[static-libs?]
"
DEPEND="${RPDEND}
	virtual/pkgconfig"

src_prepare() {
	# Upstream's patchset
	if [[ -n ${UPSTREAM_VER} ]]; then
		einfo "Try to apply tmate Upstream patch set"
		EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" \
		EPATCH_OPTS="-p1" \
			epatch "${WORKDIR}"/patches-upstream
	fi

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)
	autotools-utils_src_configure
}
