# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}

MY_PV=${PV/_/}

inherit toolchain-funcs

BOOTSTRAP_VERSION="bootstrap-1.8"
BOOTSTRAP_DIST="https://dev.gentoo.org/~williamh/dist"
BOOTSTRAP_URI="
	${BOOTSTRAP_DIST}/go-linux-amd64-${BOOTSTRAP_VERSION}.tbz
	${BOOTSTRAP_DIST}/go-linux-arm-${BOOTSTRAP_VERSION}.tbz
	${BOOTSTRAP_DIST}/go-linux-arm64-${BOOTSTRAP_VERSION}.tbz
	${BOOTSTRAP_DIST}/go-linux-ppc64-${BOOTSTRAP_VERSION}.tbz
	${BOOTSTRAP_DIST}/go-linux-ppc64le-${BOOTSTRAP_VERSION}.tbz
	${BOOTSTRAP_DIST}/go-linux-s390x-${BOOTSTRAP_VERSION}.tbz
	${BOOTSTRAP_DIST}/go-linux-386-${BOOTSTRAP_VERSION}.tbz
	${BOOTSTRAP_DIST}/go-freebsd-amd64-${BOOTSTRAP_VERSION}.tbz
	${BOOTSTRAP_DIST}/go-freebsd-386-${BOOTSTRAP_VERSION}.tbz
	${BOOTSTRAP_DIST}/go-darwin-amd64-${BOOTSTRAP_VERSION}.tbz
	${BOOTSTRAP_DIST}/go-solaris-amd64-${BOOTSTRAP_VERSION}.tbz
"

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
		KEYWORDS="-* ~amd64 ~arm ~arm64 ~ppc64 ~s390 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x64-macos ~x64-solaris"
		# The upstream tests fail under portage but pass if the build is
		# run according to their documentation [1].
		# I am restricting the tests on released versions until this is
		# solved.
		# [1] https://golang.org/issues/18442
		RESTRICT="test"
		;;
	esac
esac

# If gccgo or a previously installed version of dev-lang/go is not being
# used to build Go, there is no way to know the architecture or operating system
# of the build machine, so we need to download all of our bootstrap
# archives to allow this ebuild to work under crossdev.
#
# https://bugs.gentoo.org/671394
SRC_URI+="!gccgo? ( !system-bootstrap? ( ${BOOTSTRAP_URI} ) )"

DESCRIPTION="A concurrent garbage collected and typesafe programming language"
HOMEPAGE="https://golang.org"

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="gccgo system-bootstrap"

BDEPEND="gccgo? ( >=sys-devel/gcc-5[go] )"
RDEPEND="!<dev-go/go-tools-0_pre20150902"

# These test data objects have writable/executable stacks.
QA_EXECSTACK="
	usr/lib/go/src/debug/elf/testdata/*.obj
	usr/lib/go/src/*.gox
	"

# Do not complain about CFLAGS, etc, since Go doesn't use them.
QA_FLAGS_IGNORED='.*'

REQUIRES_EXCLUDE="/usr/lib/go/src/debug/elf/testdata/*"

# The tools in /usr/lib/go should not cause the multilib-strict check to fail.
QA_MULTILIB_PATHS="usr/lib/go/pkg/tool/.*/.*"

# Do not strip this package. Stripping is unsupported upstream and may
# fail.
RESTRICT+=" strip"

DOCS=(
AUTHORS
CONTRIBUTING.md
CONTRIBUTORS
PATENTS
README.md
)

go_arch()
{
	# By chance most portage arch names match Go
	local portage_arch=$(tc-arch $@)
	case "${portage_arch}" in
		x86)	echo 386;;
		x64-*)	echo amd64;;
		ppc64) [[ $(tc-endian $@) = big ]] && echo ppc64 || echo ppc64le ;;
		s390) echo s390x ;;
		*)		echo "${portage_arch}";;
	esac
}

go_arm()
{
	case "${1:-${CHOST}}" in
		armv5*)	echo 5;;
		armv6*)	echo 6;;
		armv7*)	echo 7;;
		*)
			die "unknown GOARM for ${1:-${CHOST}}"
			;;
	esac
}

go_os()
{
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

go_tuple()
{
	echo "$(go_os $@)_$(go_arch $@)"
}

go_cross_compile()
{
	[[ $(go_tuple ${CBUILD}) != $(go_tuple) ]]
}

pkg_pretend()
{
	# make.bash does not understand cross-compiling a cross-compiler
	if [[ $(go_tuple) != $(go_tuple ${CTARGET}) ]]; then
		die "CHOST CTARGET pair unsupported: CHOST=${CHOST} CTARGET=${CTARGET}"
	fi
	[[ ${MERGE_TYPE} != binary ]] &&
		use system-bootstrap && ! has_version "dev-lang/go" &&
		die "dev-lang/go must be installed to use the system-bootstrap use flag"
}

src_unpack()
{
	if [[ ${PV} = 9999 ]]; then
		git-r3_src_unpack
	else
		unpack "go${MY_PV}.src.tar.gz"
	fi
	use gccgo || use system-bootstrap ||
		unpack "go-$(go_os ${CBUILD})-$(go_arch ${CBUILD})-${BOOTSTRAP_VERSION}.tbz"
}

src_compile()
{
	export GOROOT_BOOTSTRAP="${WORKDIR}"/go-$(go_os ${CBUILD})-$(go_arch ${CBUILD})-bootstrap
	if use gccgo; then
		mkdir -p "${GOROOT_BOOTSTRAP}/bin" || die
		local go_binary=$(gcc-config --get-bin-path)/go-$(gcc-major-version)
		[[ -x ${go_binary} ]] || go_binary=$(
			find "${EPREFIX}"/usr/${CHOST}/gcc-bin/*/go-$(gcc-major-version) |
				sort -V | tail -n1)
		[[ -x ${go_binary} ]] ||
			die "go-$(gcc-major-version): command not found"
		ln -s "${go_binary}" "${GOROOT_BOOTSTRAP}/bin/go" || die
	elif use system-bootstrap; then
		export GOROOT_BOOTSTRAP="${EPREFIX}"/usr/lib/go
	fi
	export GOROOT_FINAL="${EPREFIX}"/usr/lib/go
	export GOROOT="$(pwd)"
	export GOBIN="${GOROOT}/bin"

	# Go's build script does not use BUILD/HOST/TARGET consistently. :(
	export GOHOSTARCH=$(go_arch ${CBUILD})
	export GOHOSTOS=$(go_os ${CBUILD})
	export CC=$(tc-getBUILD_CC)

	export GOARCH=$(go_arch)
	export GOOS=$(go_os)
	export CC_FOR_TARGET=$(tc-getCC)
	export CXX_FOR_TARGET=$(tc-getCXX)
	if [[ ${ARCH} == arm ]]; then
		export GOARM=$(go_arm)
	fi

	cd src
	./make.bash || die "build failed"
}

src_test()
{
	go_cross_compile && return 0

	cd src
	PATH="${GOBIN}:${PATH}" \
	./run.bash -no-rebuild || die "tests failed"
}

src_install()
{
	local bin_path f x

	dodir /usr/lib/go

	# There is a known issue which requires the source tree to be installed [1].
	# Once this is fixed, we can consider using the doc use flag to control
	# installing the doc and src directories.
	# [1] https://golang.org/issue/2775
	#
	# deliberately use cp to retain permissions
	cp -R api bin doc lib pkg misc src test "${ED}"/usr/lib/go
	if go_cross_compile; then
		bin_path="bin/$(go_tuple)"
	else
		bin_path=bin
	fi
	for x in ${bin_path}/*; do
		f=${x##*/}
		dosym ../lib/go/${bin_path}/${f} /usr/bin/${f}
	done
	einstalldocs

	if [[ ${CHOST} == *-darwin* ]] ; then
		# fix install_name for test object (binutils_test) on Darwin, it
		# is never used in real circumstances
		local libmac64="${EPREFIX}"/usr/lib/go/src/cmd/vendor/github.com/
		      libmac64+=google/pprof/internal/binutils/testdata/lib_mac_64
		install_name_tool -id "${libmac64}" "${D}${libmac64}"
	fi
}
