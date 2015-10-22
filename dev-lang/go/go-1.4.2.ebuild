# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

export CTARGET=${CTARGET:-${CHOST}}

inherit eutils toolchain-funcs

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://github.com/golang/go.git"
	inherit git-r3
else
	SRC_URI="https://storage.googleapis.com/golang/go${PV}.src.tar.gz"
	# Upstream only supports go on amd64, arm and x86 architectures.
	KEYWORDS="-* amd64 arm x86 ~amd64-fbsd ~x86-fbsd ~x64-macos ~x86-macos"
fi

DESCRIPTION="A concurrent garbage collected and typesafe programming language"
HOMEPAGE="http://www.golang.org"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

# These test data objects have writable/executable stacks.
QA_EXECSTACK="
	usr/lib/go/src/debug/elf/testdata/go-relocation-test-gcc482-aarch64.obj
	usr/lib/go/src/debug/elf/testdata/gcc-amd64-openbsd-debug-with-rela.obj"

	REQUIRES_EXCLUDE="/usr/lib/go/src/debug/elf/testdata/*"

# The tools in /usr/lib/go should not cause the multilib-strict check to fail.
QA_MULTILIB_PATHS="usr/lib/go/pkg/tool/.*/.*"

# The go language uses *.a files which are _NOT_ libraries and should not be
# stripped.
STRIP_MASK="/usr/lib/go/pkg/linux*/*.a /usr/lib/go/pkg/freebsd*/*.a /usr/lib/go/pkg/darwin*/*.a"

if [[ ${PV} != 9999 ]]; then
	S="${WORKDIR}"/go
fi

src_prepare()
{
	if [[ ${PV} != 9999 ]]; then
		sed -i -e 's#"-Werror",##g' src/cmd/dist/build.c ||
			die "sed failed"
	fi
	epatch_user
}

src_compile()
{
	export GOROOT_FINAL="${EPREFIX}"/usr/lib/go
	export GOROOT="$(pwd)"
	export GOBIN="${GOROOT}/bin"
	if [[ $CTARGET = armv5* ]]
	then
		export GOARM=5
	fi
	tc-export CC

	cd src
	./make.bash || die "build failed"
}

src_test()
{
	cd src
	PATH="${GOBIN}:${PATH}" \
		./run.bash --no-rebuild --banner || die "tests failed"
}

src_install()
{
	dobin bin/*
	dodoc AUTHORS CONTRIBUTORS PATENTS README

	dodir /usr/lib/go
	insinto /usr/lib/go

	# There is a known issue which requires the source tree to be installed [1].
	# Once this is fixed, we can consider using the doc use flag to control
	# installing the doc and src directories.
	# [1] https://golang.org/issue/2775
	doins -r doc include lib pkg src
	fperms -R +x /usr/lib/go/pkg/tool
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
		elog "Release notes are located at http://golang.org/doc/go1.4"
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
