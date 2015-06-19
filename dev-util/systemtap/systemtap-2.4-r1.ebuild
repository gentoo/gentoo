# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/systemtap/systemtap-2.4-r1.ebuild,v 1.8 2014/08/09 10:47:55 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit linux-info autotools eutils python-single-r1

DESCRIPTION="A linux trace/probe tool"
HOMEPAGE="http://www.sourceware.org/systemtap/"
SRC_URI="http://www.sourceware.org/${PN}/ftp/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 ~s390 sparc x86"
IUSE="sqlite"

RDEPEND=">=dev-libs/elfutils-0.142
	sys-libs/libcap
	${PYTHON_DEPS}
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.18.2"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CONFIG_CHECK="~KPROBES ~RELAY ~DEBUG_FS"
ERROR_KPROBES="${PN} requires support for KProbes Instrumentation (KPROBES) - this can be enabled in 'Instrumentation Support -> Kprobes'."
ERROR_RELAY="${PN} works with support for user space relay support (RELAY) - this can be enabled in 'General setup -> Kernel->user space relay support (formerly relayfs)'."
ERROR_DEBUG_FS="${PN} works best with support for Debug Filesystem (DEBUG_FS) - this can be enabled in 'Kernel hacking -> Debug Filesystem'."

DOCS="AUTHORS HACKING NEWS README"

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang .

	sed -i \
		-e 's:-Werror::g' \
		configure.ac \
		Makefile.am \
		staprun/Makefile.am \
		stapdyn/Makefile.am \
		buildrun.cxx \
		testsuite/systemtap.unprivileged/unprivileged_probes.exp \
		testsuite/systemtap.unprivileged/unprivileged_myproc.exp \
		testsuite/systemtap.base/stmt_rel_user.exp \
		testsuite/systemtap.base/sdt_va_args.exp \
		testsuite/systemtap.base/sdt_misc.exp \
		testsuite/systemtap.base/sdt.exp \
		scripts/kprobes_test/gen_code.py \
		|| die "Failed to clean up sources"
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--without-rpm \
		--disable-server \
		--disable-docs \
		--disable-refdocs \
		--disable-grapher \
		$(use_enable sqlite)
}
