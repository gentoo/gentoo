# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit fcaps flag-o-matic toolchain-funcs linux-info distutils-r1

DESCRIPTION="utility to checkpoint/restore a process tree"
HOMEPAGE="
	https://criu.org/
	https://github.com/checkpoint-restore/
"
SRC_URI="https://github.com/checkpoint-restore/${PN}/archive/v${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 -riscv"
IUSE="bpf doc gnutls nftables selinux setproctitle static-libs test video_cards_amdgpu"

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
	video_cards_amdgpu? ( x11-libs/libdrm[video_cards_amdgpu] )
"
DEPEND="
	${COMMON_DEPEND}
"
BDEPEND="
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
	"${FILESDIR}/criu-3.19-buildsystem.patch"
)

FILECAPS=(
	-m 0755 cap_checkpoint_restore usr/sbin/criu
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
	distutils-r1_src_prepare
	use doc || sed -i 's_\(install: \)install-man _\1_g' Makefile.install
}

criu_use() {
	if ! use "${1}"; then
		sed \
			-e "s:${2:-${1}}:no_${2:-lib${1}}:g" \
			-i Makefile.config || die
	fi
}

criu_python() {
	local -x \
		CRIU_VERSION_MAJOR="$(ver_cut 1)" \
		CRIU_VERSION_MINOR=$(ver_cut 2) \
		CRIU_VERSION_SUBLEVEL=$(ver_cut 3)

	"${@}"
}

src_configure() {
	# Gold linker generates invalid object file when used with criu's custom
	# linker script.  Use the bfd linker instead. See https://crbug.com/839665#c3
	tc-ld-force-bfd

	# the build system is quite sensitive to weird cflags
	strip-unsupported-flags
	filter-flags

	# CRIUs doesn't like LTO https://bugs.gentoo.org/910304
	filter-lto

	# Build system uses this variable as a trigger to append coverage flags
	# we'd like to avoid it. https://bugs.gentoo.org/744244
	unset GCOV

	# we have to sed the Makefile.config to disable automagic deps
	criu_use selinux
	criu_use bpf
	criu_use nftables
	criu_use video_cards_amdgpu libdrm

	emake_opts=(
		SETPROCTITLE="$(usex setproctitle)"
		NO_GNUTLS="$(usex gnutls '' '1')"
	)

	python_setup
	pushd crit >/dev/null || die
	criu_python distutils-r1_src_configure
	popd >/dev/null || die
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
		PYTHON_EXTERNALLY_MANAGED=1 \
		V=1 WERROR=0 DEBUG=0 \
		"${emake_opts[@]}" \
		"${@}"
}

src_compile() {
	local -a targets=(
		all
		$(usex video_cards_amdgpu 'amdgpu_plugin' '')
		$(usex doc 'docs' '')
	)
	criu_emake ${targets[*]}

	pushd crit >/dev/null || die
	criu_python distutils-r1_src_compile
	popd >/dev/null || die
}

src_test() {
	criu_emake unittest
}

python_install() {
	local -x \
		CRIU_VERSION_MAJOR="$(ver_cut 1)" \
		CRIU_VERSION_MINOR=$(ver_cut 2) \
		CRIU_VERSION_SUBLEVEL=$(ver_cut 3)

	distutils-r1_python_install
}

src_install() {
	criu_emake DESTDIR="${D}" install

	pushd crit >/dev/null || die
	criu_python distutils-r1_src_install
	popd >/dev/null || die

	dodoc CREDITS README.md

	if ! use static-libs; then
		find "${D}" -name "*.a" -delete || die
	fi
}
