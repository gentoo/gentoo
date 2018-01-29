# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 versionator toolchain-funcs

if [[ ${PV} = *beta* ]]; then
	betaver=${PV//*beta}
	BETA_SNAPSHOT="${betaver:0:4}-${betaver:4:2}-${betaver:6:2}"
	MY_P="rustc-beta"
	SLOT="beta/${PV}"
	SRC="${BETA_SNAPSHOT}/rustc-beta-src.tar.gz"
	KEYWORDS=""
else
	ABI_VER="$(get_version_component_range 1-2)"
	SLOT="stable/${ABI_VER}"
	MY_P="rustc-${PV}"
	SRC="${MY_P}-src.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

CHOST_amd64=x86_64-unknown-linux-gnu
CHOST_x86=i686-unknown-linux-gnu

RUST_STAGE0_VERSION="1.$(($(get_version_component_range 2) - 1)).0"
RUST_STAGE0_amd64="rust-${RUST_STAGE0_VERSION}-${CHOST_amd64}"
RUST_STAGE0_x86="rust-${RUST_STAGE0_VERSION}-${CHOST_x86}"

CARGO_DEPEND_VERSION="0.$(($(get_version_component_range 2) + 1)).0"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

SRC_URI="https://static.rust-lang.org/dist/${SRC} -> rustc-${PV}-src.tar.gz
	amd64? ( https://static.rust-lang.org/dist/${RUST_STAGE0_amd64}.tar.gz )
	x86? ( https://static.rust-lang.org/dist/${RUST_STAGE0_x86}.tar.gz )
"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="debug doc extended +jemalloc"

RDEPEND=">=app-eselect/eselect-rust-0.3_pre20150425
		jemalloc? ( dev-libs/jemalloc )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	|| (
		>=sys-devel/gcc-4.7
		>=sys-devel/clang-3.5
	)
	dev-util/cmake
"
PDEPEND="!extended? ( >=dev-util/cargo-${CARGO_DEPEND_VERSION} )"

PATCHES=( "${FILESDIR}/1.23.0-separate-libdir.patch" )

S="${WORKDIR}/${MY_P}-src"

toml_usex() {
	usex "$1" true false
}

src_prepare() {
	local rust_stage0_root="${WORKDIR}"/rust-stage0

	local rust_stage0_name="RUST_STAGE0_${ARCH}"
	local rust_stage0="${!rust_stage0_name}"

	"${WORKDIR}/${rust_stage0}"/install.sh --disable-ldconfig --destdir="${rust_stage0_root}" --prefix=/ || die

	default
}

src_configure() {
	local rust_stage0_root="${WORKDIR}"/rust-stage0

	local rust_target_name="CHOST_${ARCH}"
	local rust_target="${!rust_target_name}"

	cat <<- EOF > "${S}"/config.toml
		[llvm]
		optimize = $(toml_usex !debug)
		release-debuginfo = $(toml_usex debug)
		assertions = $(toml_usex debug)
		[build]
		build = "${rust_target}"
		host = ["${rust_target}"]
		target = ["${rust_target}"]
		cargo = "${rust_stage0_root}/bin/cargo"
		rustc = "${rust_stage0_root}/bin/rustc"
		docs = $(toml_usex doc)
		submodules = false
		python = "${EPYTHON}"
		locked-deps = true
		vendor = true
		verbose = 2
		extended = $(toml_usex extended)
		[install]
		prefix = "${EPREFIX}/usr"
		libdir = "$(get_libdir)"
		docdir = "share/doc/${P}"
		mandir = "share/${P}/man"
		[rust]
		optimize = $(toml_usex !debug)
		debuginfo = $(toml_usex debug)
		debug-assertions = $(toml_usex debug)
		use-jemalloc = $(toml_usex jemalloc)
		default-linker = "$(tc-getCC)"
		rpath = false
		[target.${rust_target}]
		cc = "$(tc-getBUILD_CC)"
		cxx = "$(tc-getBUILD_CXX)"
		linker = "$(tc-getCC)"
		ar = "$(tc-getAR)"
	EOF
}

src_compile() {
	./x.py build --verbose --config="${S}"/config.toml "${MAKEOPTS}" || die
}

src_install() {
	env DESTDIR="${D}" ./x.py install || die

	mv "${D}/usr/bin/rustc" "${D}/usr/bin/rustc-${PV}" || die
	mv "${D}/usr/bin/rustdoc" "${D}/usr/bin/rustdoc-${PV}" || die
	mv "${D}/usr/bin/rust-gdb" "${D}/usr/bin/rust-gdb-${PV}" || die
	mv "${D}/usr/bin/rust-lldb" "${D}/usr/bin/rust-lldb-${PV}" || die

	dodoc COPYRIGHT

	cat <<-EOF > "${T}"/50${P}
		LDPATH="/usr/$(get_libdir)/${P}"
		MANPATH="/usr/share/${P}/man"
	EOF
	doenvd "${T}"/50${P}

	cat <<-EOF > "${T}/provider-${P}"
		/usr/bin/rustdoc
		/usr/bin/rust-gdb
		/usr/bin/rust-lldb
	EOF
	dodir /etc/env.d/rust
	insinto /etc/env.d/rust
	doins "${T}/provider-${P}"
}

pkg_postinst() {
	eselect rust update --if-unset

	elog "Rust installs a helper script for calling GDB and LLDB,"
	elog "for your convenience it is installed under /usr/bin/rust-{gdb,lldb}-${PV}."

	if has_version app-editors/emacs || has_version app-editors/emacs-vcs; then
		elog "install app-emacs/rust-mode to get emacs support for rust."
	fi

	if has_version app-editors/gvim || has_version app-editors/vim; then
		elog "install app-vim/rust-vim to get vim support for rust."
	fi

	if has_version 'app-shells/zsh'; then
		elog "install app-shells/rust-zshcomp to get zsh completion for rust."
	fi
}

pkg_postrm() {
	eselect rust unset --if-invalid
}
