# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {16..20} )

CRATES="
"

RUST_MIN_VER="1.82.0"

inherit eapi9-ver llvm-r2 linux-info cargo rust-toolchain toolchain-funcs meson

DESCRIPTION="sched_ext schedulers and tools"
HOMEPAGE="https://github.com/sched-ext/scx"
SRC_URI="
	https://github.com/sched-ext/scx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://github.com/gentoo-crate-dist/scx/releases/download/v${PV}/scx-${PV}-crates.tar.xz
	"
fi

LICENSE="GPL-2"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD-2 BSD CC0-1.0 ISC MIT MPL-2.0 Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"

DEPEND="
	virtual/libelf:=
	sys-libs/libseccomp
	sys-libs/zlib:=
	>=dev-libs/libbpf-1.6:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	app-misc/jq
	dev-libs/protobuf[protoc(+)]
	>=dev-util/bpftool-7.5.0
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=[llvm_targets_BPF(-)]
	')
"

CONFIG_CHECK="
	~BPF
	~BPF_EVENTS
	~BPF_JIT
	~BPF_SYSCALL
	~DEBUG_INFO_BTF
	~FTRACE
	~SCHED_CLASS_EXT
"

QA_PREBUILT="
	/usr/bin/scx_loader
	/usr/bin/vmlinux_docify
	/usr/bin/scxctl
"

pkg_setup() {
	linux-info_pkg_setup
	llvm-r2_pkg_setup
	rust_pkg_setup
}

src_prepare() {
	default

	if tc-is-cross-compiler; then
		# Inject the rust_abi value into install_rust_user_scheds
		sed -i "s;\${MESON_BUILD_ROOT};\${MESON_BUILD_ROOT}/$(rust_abi);" \
			meson-scripts/install_rust_user_scheds || die
	fi
}

src_configure() {
	BUILD_DIR="${BUILD_DIR:-${WORKDIR}/${P}-build}"

	local emesonargs=(
		-Dbpf_clang="$(get_llvm_prefix)/bin/clang"
		-Dbpftool=disabled
		-Dlibbpf_a=disabled
		-Dcargo="${EPREFIX}/usr/bin/cargo"
		-Dcargo_home="${ECARGO_HOME}"
		-Doffline=true
		-Denable_rust=true
		-Dopenrc=disabled
		$(meson_feature systemd)
	)

	cargo_env meson_src_configure
}

src_compile() {
	cargo_env meson_src_compile
}

src_test() {
	cargo_env meson_src_test
}

src_install() {
	cargo_env meson_src_install

	dodoc README.md

	local readme readme_name
	for readme in scheds/{rust,c}/*/README.md ./rust/*/README.md; do
		[[ -e ${readme} ]] || continue
		readme_name="${readme#*/rust/}"
		readme_name="${readme_name#*/c/}"
		readme_name="${readme_name%/README.md}"
		newdoc "${readme}" "${readme_name}.md"
	done

	newinitd services/openrc/scx.initrd scx
	insinto /etc/default
	doins services/scx
	dosym ../default/scx /etc/conf.d/scx

	newinitd "${FILESDIR}/scx_loader.initd" scx_loader
	insinto /etc/scx_loader/
	newins services/scx_loader.toml config.toml
}

pkg_postinst() {
	if ver_replacing -lt 1.0.16; then
		ewarn "Starting in 1.0.16, the scx service is being replaced with scx_loader."
		ewarn "To transition to the new service, first edit"
		ewarn "${EPREFIX}/etc/scx_loader/config.toml with your preferred"
		ewarn "configuration, then disable the legacy scx service and enable the new"
		ewarn "scx_loader service:"
		ewarn
		ewarn "For openrc users:"
		ewarn "  rc-service scx stop"
		ewarn "  rc-update del scx default"
		ewarn "  rc-service scx_loader start"
		ewarn "  rc-update add scx_loader default"
		ewarn
		ewarn "For systemd users:"
		ewarn "  systemctl disable --now scx"
		ewarn "  systemctl enable --now scx_loader"
		ewarn
		ewarn "For more info, see:"
		ewarn "https://wiki.cachyos.org/configuration/sched-ext/#transitioning-from-scxservice-to-scx_loader-a-comprehensive-guide"
	fi
}
