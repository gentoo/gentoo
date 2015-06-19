# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/go-bootstrap/go-bootstrap-1.4.2.ebuild,v 1.1 2015/03/18 00:51:29 williamh Exp $

EAPI=5

export CTARGET=${CTARGET:-${CHOST}}

inherit eutils toolchain-funcs

SRC_URI="https://storage.googleapis.com/golang/go${PV}.src.tar.gz"
# Upstream only supports go on amd64, arm and x86 architectures.
KEYWORDS="-* ~amd64 ~arm ~x86 ~amd64-fbsd ~x86-fbsd ~x64-macos ~x86-macos"

DESCRIPTION="Version of go compiler used for bootstrapping"
HOMEPAGE="http://www.golang.org"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

# The go tools should not cause the multilib-strict check to fail.
QA_MULTILIB_PATHS="usr/lib/go1.4/pkg/tool/.*/.*"

# The go language uses *.a files which are _NOT_ libraries and should not be
# stripped.
STRIP_MASK="/usr/lib/go1.4/pkg/linux*/*.a
	/usr/lib/go1.4/pkg/freebsd*/*.a /usr/lib/go1.4/pkg/darwin*/*.a"

S="${WORKDIR}"/go

src_prepare()
{
	sed -i -e 's/"-Werror",//g' src/cmd/dist/build.c
}

src_compile()
{
	export GOROOT_FINAL="${EPREFIX}"/usr/lib/go1.4
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
	dodir /usr/lib/go1.4
	exeinto /usr/lib/go1.4/bin
doexe bin/*
	insinto /usr/lib/go1.4
	doins -r lib pkg src
	fperms -R +x /usr/lib/go1.4/pkg/tool
}

pkg_postinst()
{
	# If the go tool sees a package file timestamped older than a dependancy it
	# will rebuild that file.  So, in order to stop go from rebuilding lots of
	# packages for every build we need to fix the timestamps.  The compiler and
	# linker are also checked - so we need to fix them too.
	ebegin "fixing timestamps to avoid unnecessary rebuilds"
	tref="usr/lib/go1.4/pkg/*/runtime.a"
	find "${EROOT}"usr/lib/go1.4 -type f \
		-exec touch -r "${EROOT}"${tref} {} \;
	eend $?
}
