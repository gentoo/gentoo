# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic linux-info pam systemd

DESCRIPTION="Tools and libraries to configure and manage kernel control groups"
HOMEPAGE="http://libcg.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/libcg/${PN}/v${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+daemon elibc_musl pam static-libs test +tools"
REQUIRED_USE="daemon? ( tools )"

# Use mount cgroup to build directory
# sandbox restricted to trivial build,
RESTRICT="test"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	elibc_musl? ( sys-libs/fts-standalone )
"
DEPEND="pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-replace-DECLS.patch
	"${FILESDIR}"/${P}-replace-INLCUDES.patch
	"${FILESDIR}"/${P}-reorder-headers.patch
	"${FILESDIR}"/${P}-remove-umask.patch
)

pkg_setup() {
	local CONFIG_CHECK="~CGROUPS"
	if use daemon; then
		CONFIG_CHECK="${CONFIG_CHECK} ~CONNECTOR ~PROC_EVENTS"
	fi
	linux-info_pkg_setup
}

PATCHES=(
	"${FILESDIR}"/${P}-replace_DECLS.patch
	"${FILESDIR}"/${P}-replace_INLCUDES.patch
	"${FILESDIR}"/${P}-reorder-headers.patch
	"${FILESDIR}"/${P}-remove-umask.patch
	"${FILESDIR}"/${P}-slibtool.patch
)

src_prepare() {
	default
	# Change rules file location
	sed -e 's:/etc/cgrules.conf:/etc/cgroup/cgrules.conf:' \
		-i src/libcgroup-internal.h || die "sed failed"
	sed -e 's:/etc/cgconfig.conf:/etc/cgroup/cgconfig.conf:' \
		-i src/libcgroup-internal.h || die "sed failed"
	sed -e 's:\(pam_cgroup_la_LDFLAGS.*\):\1\ -avoid-version:' \
		-i src/pam/Makefile.am || die "sed failed"
	sed -e 's#/var/run#/run#g' -i configure.in || die "sed failed"

	# If we're not running tests, don't bother building them.
	if ! use test; then
		sed -i '/^SUBDIRS/s:tests::' Makefile.am || die
	fi

	# Workaround configure.in
	mv configure.in configure.ac || die

	eautoreconf
}

src_configure() {
	local my_conf

	if use pam; then
		my_conf=" --enable-pam-module-dir=$(getpam_mod_dir) "
	fi

	use elibc_musl && append-ldflags "-lfts"
	econf \
		$(use_enable static-libs static) \
		$(use_enable daemon) \
		$(use_enable pam) \
		$(use_enable tools) \
		${my_conf}
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	insinto /etc/cgroup
	doins samples/*.conf

	if use tools; then
		newconfd "${FILESDIR}"/cgconfig.confd-r1 cgconfig
		newinitd "${FILESDIR}"/cgconfig.initd-r1 cgconfig
		systemd_dounit "${FILESDIR}"/cgconfig.service
		systemd_dounit "${FILESDIR}"/cgrules.service
	fi

	if use daemon; then
		newconfd "${FILESDIR}"/cgred.confd-r2 cgred
		newinitd "${FILESDIR}"/cgred.initd-r1 cgred
	fi
}
