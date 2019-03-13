# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

if [[ ${PV} == *9999* ]]; then
	SRC_ECLASS="git-2"
	EGIT_REPO_URI="anongit.gentoo.org/proj/catalyst.git"
	EGIT_MASTER="master"
	S="${WORKDIR}/${PN}"
else
	SRC_URI="mirror://gentoo/${P}.tar.bz2
		https://dev.gentoo.org/~jmbsvicetto/distfiles/${P}.tar.bz2
		https://dev.gentoo.org/~mattst88/distfiles/${P}.tar.bz2
		https://dev.gentoo.org/~zerochaos/distfiles/${P}.tar.bz2
		https://dev.gentoo.org/~dolsen/releases/catalyst/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
fi

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-single-r1 ${SRC_ECLASS}

DESCRIPTION="Release metatool used for creating releases based on Gentoo Linux"
HOMEPAGE="https://wiki.gentoo.org/wiki/Catalyst"

LICENSE="GPL-2"
SLOT="0"
IUSE="ccache kernel_linux"

DEPEND="
	app-text/asciidoc
	${PYTHON_DEPS}
"
RDEPEND="
	app-arch/lbzip2
	app-crypt/shash
	app-arch/tar[xattr]
	sys-fs/dosfstools
	virtual/cdrtools
	amd64? ( >=sys-boot/syslinux-3.72 )
	x86? ( >=sys-boot/syslinux-3.72 )
	ccache? ( dev-util/ccache )
	kernel_linux? ( app-misc/zisofs-tools >=sys-fs/squashfs-tools-2.1 )
	${PYTHON_DEPS}
"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

PATCHES=(
	"${FILESDIR}/catalyst-2.0.18-Do-notuntarwith--acls.patch"
	"${FILESDIR}/catalyst-2.0.18-fix-quotes.patch"
	"${FILESDIR}/catalyst-2.0.18-remove-machine-id.patch"
	"${FILESDIR}/catalyst-2.0.18-stage1-export-ROOT.patch"
)

pkg_setup() {
	if use ccache ; then
		einfo "Enabling ccache support for catalyst."
	else
		ewarn "By default, ccache support for catalyst is disabled."
		ewarn "If this is not what you intended,"
		ewarn "then you should add ccache to your USE."
	fi

	echo
	einfo "The template spec files are now installed by default.  You can find"
	einfo "them under /usr/share/doc/${PF}/examples"
	einfo "and they are considered to be the authorative source of information"
	einfo "on catalyst."
	echo

	python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${PATCHES[@]}"
}

src_install() {
	insinto /usr/$(get_libdir)/${PN}
	exeinto /usr/$(get_libdir)/${PN}
	doexe catalyst || die "copying catalyst"

	if [[ ${PV} == 3.9999* ]]; then
		doins -r modules files || die "copying files"
	else
		doins -r arch modules livecd || die "copying files"
	fi

	for x in targets/*; do
		exeinto /usr/$(get_libdir)/${PN}/$x
		doexe $x/* || die "copying ${x}"
	done

	# Here is where we actually enable ccache
	use ccache && \
		sed -i -e 's:options="autoresume kern:options="autoresume ccache kern:' \
			files/catalyst.conf

	sed -i -e "s:/usr/lib/catalyst:/usr/$(get_libdir)/catalyst:" \
		files/catalyst.conf

	make_wrapper catalyst /usr/$(get_libdir)/${PN}/catalyst
	insinto /etc/catalyst
	doins files/catalyst.conf files/catalystrc || die "copying configuration"
	insinto /usr/share/doc/${PF}/examples
	doins examples/* || die
	dodoc README AUTHORS
	doman files/catalyst.1 files/catalyst-spec.5

	python_fix_shebang "${ED}usr/$(get_libdir)/catalyst/catalyst"
	python_optimize "${ED}"
}

pkg_postinst() {
	einfo "You can find more information about catalyst by checking out the"
	einfo "catalyst project page at:"
	einfo "https://wiki.gentoo.org/wiki/Catalyst"
}
