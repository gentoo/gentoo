# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit linux-info autotools python-single-r1

DESCRIPTION="A linux trace/probe tool"
HOMEPAGE="https://www.sourceware.org/systemtap/"
SRC_URI="https://www.sourceware.org/${PN}/ftp/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="libvirt sqlite"

RDEPEND=">=dev-libs/elfutils-0.142
	sys-libs/libcap
	${PYTHON_DEPS}
	libvirt? ( >=app-emulation/libvirt-1.0.2 )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}
	dev-python/setuptools
	>=sys-devel/gettext-0.18.2"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CONFIG_CHECK="~KPROBES ~RELAY ~DEBUG_FS"
ERROR_KPROBES="${PN} requires support for KProbes Instrumentation (KPROBES) - this can be enabled in 'Instrumentation Support -> Kprobes'."
ERROR_RELAY="${PN} works with support for user space relay support (RELAY) - this can be enabled in 'General setup -> Kernel->user space relay support (formerly relayfs)'."
ERROR_DEBUG_FS="${PN} works best with support for Debug Filesystem (DEBUG_FS) - this can be enabled in 'Kernel hacking -> Debug Filesystem'."

DOCS="AUTHORS HACKING NEWS README"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3-sandboxfix.patch
)

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang .

	default

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
		$(use_enable libvirt virt) \
		$(use_enable sqlite)
}

pkg_preinst() {
	# The users and groups created here would nominally be created by
	# systemtap's build system; systemtap checks to see if it's being built
	# using uid 0, and runs groupadd/useradd.
	homedir=/var/lib/stap-server
	enewgroup stap-server 155
	enewgroup stapusr 156
	enewgroup stapsys 157
	enewgroup stapdev 158
	enewuser stap-server 155 /sbin/nologin "${homedir}" stap-server
	enewuser stapusr 156 /sbin/nologin "${homedir}" stapusr
	enewuser stapsys 157 /sbin/nologin "${homedir}" stapsys
	enewuser stapdev 158 /sbin/nologin "${homedir}" stapdev
}
