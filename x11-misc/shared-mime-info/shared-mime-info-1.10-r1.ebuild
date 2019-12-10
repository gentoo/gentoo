# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic xdg-utils

DESCRIPTION="The Shared MIME-info Database specification"
HOMEPAGE="https://freedesktop.org/wiki/Software/shared-mime-info"
SRC_URI="https://people.freedesktop.org/~hadess/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/glib-2
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( ChangeLog HACKING NEWS README )

src_configure() {
	export ac_cv_func_fdatasync=no #487504

	if [[ ${PV} == 1.10 ]]; then
		# https://bugs.gentoo.org/684884
		append-lfs-flags
	else
		eerror "LFS support merged upstream."
		eerror "https://gitlab.freedesktop.org/xdg/shared-mime-info/merge_requests/20"
		die "Please remove LFS workaround."
	fi

	local myeconfargs=(
		$(use_enable test default-make-check)
		--disable-update-mimedb
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	# FIXME: 0.91 fails with -j9 every second time like:
	# update_mime_database-update-mime-database.o: file not recognized: File truncated
	# collect2: ld returned 1 exit status
	emake -j1
}

src_install() {
	default

	# in prefix, install an env.d entry such that prefix patch is used/added
	if use prefix; then
		echo "XDG_DATA_DIRS=\"${EPREFIX}/usr/share\"" > "${T}"/50mimeinfo || die
		doenvd "${T}"/50mimeinfo
	fi
}

pkg_postinst() {
	use prefix && export XDG_DATA_DIRS="${EPREFIX}"/usr/share
	xdg_mimeinfo_database_update
}
