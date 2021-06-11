# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}

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
		KEYWORDS="-* amd64 ~arm ~arm64 ppc64 ~s390 x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
		;;
	esac
esac

DESCRIPTION="A concurrent garbage collected and typesafe programming language"
HOMEPAGE="https://golang.org"

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="cpu_flags_x86_sse2"

BDEPEND="|| (
		dev-lang/go
		dev-lang/go-bootstrap )"
RDEPEND="!<dev-go/go-tools-0_pre20150902"

# Do not complain about CFLAGS, etc, since Go doesn't use them.
QA_FLAGS_IGNORED='.*'

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

go_arch() {
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

src_compile() {
	if has_version -b dev-lang/go; then
		export GOROOT_BOOTSTRAP="${BROOT}/usr/lib/go"
	elif has_version -b dev-lang/go-bootstrap; then
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
	PATH="${GOBIN}:${PATH}" \
	./run.bash -no-rebuild || die "tests failed"
	cd ..
	rm -fr pkg/*_race || die
	rm -fr pkg/obj/go-build || die
}

src_install() {
	# There is a known issue which requires the source tree to be installed [1].
	# Once this is fixed, we can consider using the doc use flag to control
	# installing the doc and src directories.
	# The use of cp is deliberate in order to retain permissions
	# [1] https://golang.org/issue/2775
	dodir /usr/lib/go
	cp -R api bin doc lib pkg misc src test "${ED}"/usr/lib/go
	einstalldocs

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
	einfo "After ${CATEGORY}/${PN} is updated it is recommended to rebuild"
	einfo "all packages compiled with previous versions of ${CATEGORY}/${PN}"
	einfo "due to the static linking nature of go."
	einfo "If this is not done, the packages compiled with the older"
	einfo "version of the compiler will not be updated until they are"
	einfo "updated individually, which could mean they will have"
	einfo "vulnerabilities."
	einfo "Run 'emerge @golang-rebuild' to rebuild all 'go' packages"
	einfo "See https://bugs.gentoo.org/752153 for more info"
}
