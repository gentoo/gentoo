# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}

inherit eutils toolchain-funcs

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://github.com/golang/go.git"
	inherit git-r3
else
	SRC_URI="https://storage.googleapis.com/golang/go${PV}.src.tar.gz"
	# go-bootstrap-1.4 only supports go on amd64, arm and x86 architectures.
	# Allowing other bootstrap options would enable arm64 and ppc64 builds.
	KEYWORDS="-* ~amd64 ~arm ~x86 ~amd64-fbsd ~x86-fbsd ~x64-macos ~x86-macos ~x64-solaris"
fi

DESCRIPTION="A concurrent garbage collected and typesafe programming language"
HOMEPAGE="http://www.golang.org"

LICENSE="BSD"
SLOT="0/${PV}"
IUSE=""

DEPEND=">=dev-lang/go-bootstrap-1.4.1"
RDEPEND="!<dev-go/go-tools-0_pre20150902"

# These test data objects have writable/executable stacks.
QA_EXECSTACK="usr/lib/go/src/debug/elf/testdata/*.obj"

REQUIRES_EXCLUDE="/usr/lib/go/src/debug/elf/testdata/*"

# The tools in /usr/lib/go should not cause the multilib-strict check to fail.
QA_MULTILIB_PATHS="usr/lib/go/pkg/tool/.*/.*"

# The go language uses *.a files which are _NOT_ libraries and should not be
# stripped. The test data objects should also be left alone and unstripped.
STRIP_MASK="/usr/lib/go/pkg/*.a
	/usr/lib/go/src/debug/elf/testdata/*
	/usr/lib/go/src/debug/dwarf/testdata/*
	/usr/lib/go/src/runtime/race/*.syso"

if [[ ${PV} != 9999 ]]; then
	S="${WORKDIR}"/go
fi

go_arch()
{
	# By chance most portage arch names match Go
	local portage_arch=$(tc-arch $@)
	case "${portage_arch}" in
		x86)	echo 386;;
		x64-*)	echo amd64;;
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
}

src_compile()
{
	export GOROOT_BOOTSTRAP="${EPREFIX}"/usr/lib/go1.4
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
	insinto /usr/lib/go

	# There is a known issue which requires the source tree to be installed [1].
	# Once this is fixed, we can consider using the doc use flag to control
	# installing the doc and src directories.
	# [1] https://golang.org/issue/2775
	doins -r bin doc lib pkg src
	fperms -R +x /usr/lib/go/bin /usr/lib/go/pkg/tool

	if go_cross_compile; then
		bin_path="bin/$(go_tuple)"
	else
		bin_path=bin
	fi
	for x in ${bin_path}/*; do
		f=${x##*/}
		dosym ../lib/go/${bin_path}/${f} /usr/bin/${f}
	done

	dodir /usr/lib/go/misc
	insinto /usr/lib/go/misc
	doins -r misc/trace

	dodoc AUTHORS CONTRIBUTORS PATENTS README.md
}

pkg_preinst()
{
	has_version '<dev-lang/go-1.4' &&
		export had_support_files=true ||
		export had_support_files=false
}

pkg_postinst()
{
	# If the go tool sees a package file timestamped older than a dependancy it
	# will rebuild that file.  So, in order to stop go from rebuilding lots of
	# packages for every build we need to fix the timestamps.  The compiler and
	# linker are also checked - so we need to fix them too.
	ebegin "fixing timestamps to avoid unnecessary rebuilds"
	tref="usr/lib/go/pkg/*/runtime.a"
	find "${EROOT}"usr/lib/go -type f \
		-exec touch -r "${EROOT}"${tref} {} \;
	eend $?

	if [[ ${PV} != 9999 && -n ${REPLACING_VERSIONS} &&
		${REPLACING_VERSIONS} != ${PV} ]]; then
		elog "Release notes are located at http://golang.org/doc/go${PV}"
	fi

	if $had_support_files; then
		ewarn
		ewarn "All editor support, IDE support, shell completion"
		ewarn "support, etc has been removed from the go package"
		ewarn "upstream."
		ewarn "For more information on which support is available, see"
		ewarn "the following URL:"
		ewarn "https://github.com/golang/go/wiki/IDEsAndTextEditorPlugins"
	fi
}
