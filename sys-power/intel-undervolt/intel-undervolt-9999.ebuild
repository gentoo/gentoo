# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd toolchain-funcs

DESCRIPTION="Intel CPU undervolting and throttling configuration tool"
HOMEPAGE="https://github.com/kitsunyan/intel-undervolt"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kitsunyan/${PN}.git"
else
	SRC_URI="https://github.com/kitsunyan/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="-* ~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="elogind"

DEPEND="elogind? ( sys-auth/elogind )"

RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~INTEL_RAPL ~X86_MSR"

src_configure() {
	local myconf=(
		# it's a non-standard build system
		$(usex elogind --enable-elogind '')
		--enable-openrc
		--enable-systemd
		--unitdir="$(systemd_get_systemunitdir)"
	)

	econf "${myconf[@]}"
}

src_compile() {
	tc-export CC

	local myemakeargs=(
		CC="${CC}"
		CFLAGS="${CFLAGS}"
	)

	emake "${myemakeargs[@]}"
}

pkg_postinst() {
	for v in ${REPLACING_VERSIONS}; do
		if [[ ${v} == 1.6 ]] ; then
			elog "openrc service has been renamed to intel-undervolt-loop"
			elog "please update your startup configuration"
		fi
	done
}
