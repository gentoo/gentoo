# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}

# See "Bootstrap" in release notes
GO_BOOTSTRAP_MIN=1.17.13
MY_PV=${PV/_/}

inherit toolchain-funcs

case ${PV}  in
*9999*)
	EGIT_REPO_URI="https://github.com/golang/go.git"
	inherit git-r3
	;;
*)
	SRC_URI="https://storage.googleapis.com/golang/go${MY_PV}.src.tar.gz "
	S="${WORKDIR}"/go
	case ${PV} in
	*_beta*|*_rc*) ;;
	*)
		KEYWORDS="-* ~amd64 ~arm ~arm64 ~loong ~mips ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
		;;
	esac
esac

DESCRIPTION="A concurrent garbage collected and typesafe programming language"
HOMEPAGE="https://go.dev"

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="abi_mips_o32 abi_mips_n64 cpu_flags_x86_sse2"

RDEPEND="
arm? ( sys-devel/binutils[gold] )
arm64? ( sys-devel/binutils[gold] )"
BDEPEND="|| (
		>=dev-lang/go-${GO_BOOTSTRAP_MIN}
		>=dev-lang/go-bootstrap-${GO_BOOTSTRAP_MIN} )"

# the *.syso files have writable/executable stacks
QA_EXECSTACK='*.syso'

# Do not complain about CFLAGS, etc, since Go doesn't use them.
QA_FLAGS_IGNORED='.*'

# The tools in /usr/lib/go should not cause the multilib-strict check to fail.
QA_MULTILIB_PATHS="usr/lib/go/pkg/tool/.*/.*"

# This package triggers "unrecognized elf file(s)" notices on riscv.
# https://bugs.gentoo.org/794046
QA_PREBUILT='.*'

# Do not strip this package. Stripping is unsupported upstream and may
# fail.
RESTRICT+=" strip"

DOCS=(
	CONTRIBUTING.md
	PATENTS
	README.md
	SECURITY.md
)

go_arch() {
	# By chance most portage arch names match Go
	local tc_arch=$(tc-arch $@)
	case "${tc_arch}" in
		x86)	echo 386;;
		x64-*)	echo amd64;;
		loong)	echo loong64;;
		mips) if use abi_mips_o32; then
				[[ $(tc-endian $@) = big ]] && echo mips || echo mipsle
			elif use abi_mips_n64; then
				[[ $(tc-endian $@) = big ]] && echo mips64 || echo mips64le
			fi ;;
		ppc64) [[ $(tc-endian $@) = big ]] && echo ppc64 || echo ppc64le ;;
		riscv) echo riscv64 ;;
		s390) echo s390x ;;
		*)		echo "${tc_arch}";;
	esac
}

go_arm() {
	case "${1:-${CHOST}}" in
		armv5*)	echo 5;;
		armv6*)	echo 6;;
		armv7*)	echo 7;;
		*)
			die "unknown GOARM for ${1:-${CHOST}}"
			;;
	esac
}

go_os() {
	case "${1:-${CHOST}}" in
		*-linux*)	echo linux;;
		*-darwin*)	echo darwin;;
		*-freebsd*)	echo freebsd;;
		*-netbsd*)	echo netbsd;;
		*-openbsd*)	echo openbsd;;
		*-solaris*)	echo solaris;;
		*-cygwin*|*-interix*|*-winnt*)
			echo windows
			;;
		*)
			die "unknown GOOS for ${1:-${CHOST}}"
			;;
	esac
}

go_tuple() {
	echo "$(go_os $@)_$(go_arch $@)"
}

go_cross_compile() {
	[[ $(go_tuple ${CBUILD}) != $(go_tuple) ]]
}

PATCHES=(
	"${FILESDIR}"/go-never-download-newer-toolchains.patch
)

src_compile() {
	if has_version -b ">=dev-lang/go-${GO_BOOTSTRAP_MIN}"; then
		export GOROOT_BOOTSTRAP="${BROOT}/usr/lib/go"
	elif has_version -b ">=dev-lang/go-bootstrap-${GO_BOOTSTRAP_MIN}"; then
		export GOROOT_BOOTSTRAP="${BROOT}/usr/lib/go-bootstrap"
	else
		eerror "Go cannot be built without go or go-bootstrap installed"
		die "Should not be here, please report a bug"
	fi

	export GOROOT_FINAL="${EPREFIX}"/usr/lib/go
	export GOROOT="${PWD}"
	export GOBIN="${GOROOT}/bin"

	# Go's build script does not use BUILD/HOST/TARGET consistently. :(
	export GOHOSTARCH=$(go_arch ${CBUILD})
	export GOHOSTOS=$(go_os ${CBUILD})
	export CC=$(tc-getBUILD_CC)

	export GOARCH=$(go_arch)
	export GOOS=$(go_os)
	export CC_FOR_TARGET=$(tc-getCC)
	export CXX_FOR_TARGET=$(tc-getCXX)
	use arm && export GOARM=$(go_arm)
	use x86 && export GO386=$(usex cpu_flags_x86_sse2 '' 'softfloat')

	cd src
	bash -x ./make.bash || die "build failed"
}

src_test() {
	go_cross_compile && return 0

	cd src

	# https://github.com/golang/go/issues/42005
	rm cmd/link/internal/ld/fallocate_test.go || true

	PATH="${GOBIN}:${PATH}" \
	./run.bash -no-rebuild -k || die "tests failed"
	cd ..
	rm -fr pkg/*_race || die
	rm -fr pkg/obj/go-build || die
}

src_install() {
	dodir /usr/lib/go
	# The use of cp is deliberate in order to retain permissions
	cp -R api bin doc lib pkg misc src test "${ED}"/usr/lib/go
	einstalldocs

	insinto /usr/lib/go
doins go.env VERSION

	# testdata directories are not needed on the installed system
	rm -fr $(find "${ED}"/usr/lib/go -iname testdata -type d -print)

	local bin_path
	if go_cross_compile; then
		bin_path="bin/$(go_tuple)"
	else
		bin_path=bin
	fi
	local f x
	for x in ${bin_path}/*; do
		f=${x##*/}
		dosym ../lib/go/${bin_path}/${f} /usr/bin/${f}
	done

	# install the @golang-rebuild set for Portage
	insinto /usr/share/portage/config/sets
	newins "${FILESDIR}"/go-sets.conf go.conf
}

pkg_postinst() {
	[[ -z ${REPLACING_VERSIONS} ]] && return
	elog "After ${CATEGORY}/${PN} is updated it is recommended to rebuild"
	elog "all packages compiled with previous versions of ${CATEGORY}/${PN}"
	elog "due to the static linking nature of go."
	elog "If this is not done, the packages compiled with the older"
	elog "version of the compiler will not be updated until they are"
	elog "updated individually, which could mean they will have"
	elog "vulnerabilities."
	elog "Run 'emerge @golang-rebuild' to rebuild all 'go' packages"
	elog "See https://bugs.gentoo.org/752153 for more info"
}
