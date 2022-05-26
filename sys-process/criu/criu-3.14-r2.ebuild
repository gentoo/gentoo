# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} )

inherit toolchain-funcs linux-info python-r1

DESCRIPTION="utility to checkpoint/restore a process tree"
HOMEPAGE="https://criu.org/"
SRC_URI="https://download.openvz.org/criu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 -riscv"
IUSE="doc selinux setproctitle static-libs"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/protobuf-c
	dev-libs/libnl:3
	net-libs/libnet:1.1
	sys-libs/libcap
	selinux? ( sys-libs/libselinux )
	setproctitle? ( dev-libs/libbsd )"
DEPEND="${RDEPEND}
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)"
RDEPEND="${RDEPEND}
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/ipaddr[${PYTHON_USEDEP}]
"

CONFIG_CHECK="~CHECKPOINT_RESTORE ~NAMESPACES ~PID_NS ~FHANDLE ~EVENTFD ~EPOLL ~INOTIFY_USER
	~UNIX_DIAG ~INET_DIAG ~INET_UDP_DIAG ~PACKET_DIAG ~NETLINK_DIAG ~TUN ~NETFILTER_XT_MARK"

# root access required for tests
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/2.2/${PN}-2.2-flags.patch
	"${FILESDIR}"/2.3/${PN}-2.3-no-git.patch
	"${FILESDIR}"/${PN}-3.12-automagic-libbsd.patch
)

criu_arch() {
	# criu infers the arch from $(uname -m).  We never want this to happen.
	case ${ARCH} in
		amd64) echo "x86";;
		arm64) echo "aarch64";;
		ppc64*) echo "ppc64";;
		*)     echo "${ARCH}";;
	esac
}

pkg_setup() {
	use amd64 && CONFIG_CHECK+=" ~IA32_EMULATION"
	linux-info_pkg_setup
}

src_prepare() {
	default

	if ! use selinux; then
		sed \
			-e 's:libselinux:no_libselinux:g' \
			-i Makefile.config || die
	fi

	use doc || sed -i 's_\(install: \)install-man _\1_g' Makefile.install
}

src_configure() {
	# Gold linker generates invalid object file when used with criu's custom
	# linker script.  Use the bfd linker instead. See https://crbug.com/839665#c3
	tc-ld-disable-gold

	# Build system uses this variable as a trigger to append coverage flags
	# we'd like to avoid it. https://bugs.gentoo.org/744244
	unset GCOV

	python_setup
}

src_compile() {
	local target="all $(usex doc 'docs' '')"
	emake \
		HOSTCC="$(tc-getBUILD_CC)" \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		AR="$(tc-getAR)" \
		PYTHON="${EPYTHON%.?}" \
		FULL_PYTHON="${PYTHON%.?}" \
		OBJCOPY="$(tc-getOBJCOPY)" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		ARCH="$(criu_arch)" \
		V=1 WERROR=0 DEBUG=0 \
		SETPROCTITLE=$(usex setproctitle) \
		${target}
}

src_test() {
	# root privileges are required to dump all necessary info
	if [[ ${EUID} -eq 0 ]] ; then
		emake -j1 CC="$(tc-getCC)" ARCH="$(criu_arch)" V=1 WERROR=0 test
	fi
}

install_crit() {
	"${EPYTHON}" scripts/crit-setup.py install --root="${D}" --prefix="${EPREFIX}/usr/" || die
	python_optimize
}

src_install() {
	emake \
		ARCH="$(criu_arch)" \
		PREFIX="${EPREFIX}"/usr \
		PYTHON="${EPYTHON%.?}" \
		FULL_PYTHON="${PYTHON%.?}" \
		LOGROTATEDIR="${EPREFIX}"/etc/logrotate.d \
		DESTDIR="${D}" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		V=1 WERROR=0 DEBUG=0 \
		install

	use doc && dodoc CREDITS README.md

	python_foreach_impl install_crit

	if ! use static-libs; then
		find "${D}" -name "*.a" -delete || die
	fi
}
