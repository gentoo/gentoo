# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit toolchain-funcs linux-info python-r1

DESCRIPTION="utility to checkpoint/restore a process tree"
HOMEPAGE="
	https://criu.org/
	https://github.com/checkpoint-restore/
"
SRC_URI="https://github.com/checkpoint-restore/${PN}/archive/v${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 -riscv"
IUSE="bpf doc gnutls nftables selinux setproctitle static-libs test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=dev-libs/protobuf-c-1.4.0:=
	dev-libs/libnl:3=
	net-libs/libnet:1.1=
	sys-libs/libcap:=
	bpf? ( dev-libs/libbpf:= )
	gnutls? ( net-libs/gnutls:= )
	nftables? ( net-libs/gnutls:= )
	selinux? ( sys-libs/libselinux:= )
	setproctitle? ( dev-libs/libbsd:= )
"
DEPEND="${COMMON_DEPEND}"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)
"
RDEPEND="
	${COMMON_DEPEND}
	dev-python/protobuf-python[${PYTHON_USEDEP}]
"

CONFIG_CHECK="~CHECKPOINT_RESTORE ~NAMESPACES ~PID_NS ~FHANDLE ~EVENTFD ~EPOLL ~INOTIFY_USER
	~UNIX_DIAG ~INET_DIAG ~INET_UDP_DIAG ~PACKET_DIAG ~NETLINK_DIAG ~TUN ~NETFILTER_XT_MARK"

# root access required for tests
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/2.2/criu-2.2-flags.patch"
	"${FILESDIR}/2.3/criu-2.3-no-git.patch"
	"${FILESDIR}/criu-3.12-automagic-libbsd.patch"
	"${FILESDIR}/criu-3.16.1-buildsystem.patch"

	"${FILESDIR}/${P}-amdgpu-build-fixes.patch"
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

	use doc || sed -i 's_\(install: \)install-man _\1_g' Makefile.install
}

criu_use() {
	if ! use "${1}"; then
		sed \
			-e "s:${2:-${1}}:no_${2:-lib${1}}:g" \
			-i Makefile.config || die
	fi
}

src_configure() {
	# Gold linker generates invalid object file when used with criu's custom
	# linker script.  Use the bfd linker instead. See https://crbug.com/839665#c3
	tc-ld-disable-gold

	# Build system uses this variable as a trigger to append coverage flags
	# we'd like to avoid it. https://bugs.gentoo.org/744244
	unset GCOV

	# we have to sed the Makdfile.config to disable automagic deps
	criu_use selinux
	criu_use bpf
	criu_use nftables

	emake_opts=(
		SETPROCTITLE="$(usex setproctitle)"
		NO_GNUTLS="$(usex gnutls '' '1')"
	)

	python_setup
}

criu_emake() {
	emake \
		AR="$(tc-getAR)" \
		ARCH="$(criu_arch)" \
		CC="$(tc-getCC)" \
		FULL_PYTHON="${PYTHON%.*}" \
		HOSTCC="$(tc-getBUILD_CC)" \
		LD="$(tc-getLD)" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		LOGROTATEDIR="${EPREFIX}"/etc/logrotate.d \
		OBJCOPY="$(tc-getOBJCOPY)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		PREFIX="${EPREFIX}"/usr \
		PYTHON="${EPYTHON%.*}" \
		V=1 WERROR=0 DEBUG=0 \
		"${emake_opts[@]}" \
		"${@}"
}

build_crit() {
	"${EPYTHON}" scripts/crit-setup.py build || die
}

src_compile() {
	local -a targets=(
		all
		$(usex doc 'docs' '')
	)
	criu_emake ${targets}
}

src_test() {
	criu_emake unittest
}

install_crit() {
	"${EPYTHON}" scripts/crit-setup.py install --root="${D}" --prefix="${EPREFIX}/usr/" || die
	python_optimize
}

src_install() {
	criu_emake DESTDIR="${D}" install
	python_foreach_impl install_crit

	dodoc CREDITS README.md

	if ! use static-libs; then
		find "${D}" -name "*.a" -delete || die
	fi
}
