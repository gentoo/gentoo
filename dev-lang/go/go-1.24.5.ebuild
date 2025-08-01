# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}

# See "Bootstrap" in release notes
GO_BOOTSTRAP_MIN=1.22.12
MY_PV=${PV/_/}

inherit go-env toolchain-funcs

case ${PV}  in
*9999*)
	EGIT_REPO_URI="https://github.com/golang/go.git"
	inherit git-r3
	;;
*)
	SRC_URI="https://storage.googleapis.com/golang/go${MY_PV}.src.tar.gz "
	S="${WORKDIR}"/go
	KEYWORDS="-* amd64 ~arm ~arm64 ~loong ~mips ppc64 ~riscv ~s390 x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
	;;
esac

DESCRIPTION="A concurrent garbage collected and typesafe programming language"
HOMEPAGE="https://go.dev"

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="cpu_flags_x86_sse2"

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
RESTRICT=" strip"

DOCS=(
	CONTRIBUTING.md
	PATENTS
	README.md
	SECURITY.md
)

go_tuple() {
	echo "$(go-env_goos $@)_$(go-env_goarch $@)"
}

go_cross_compile() {
	[[ $(go_tuple ${CBUILD}) != $(go_tuple) ]]
}

PATCHES=(
	"${FILESDIR}"/go-1.24-skip-gdb-tests.patch
	"${FILESDIR}"/go-1.24-dont-force-gold-arm.patch
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

	# Go's build script does not use BUILD/HOST/TARGET consistently. :(
	export GOHOSTARCH=$(go-env_goarch ${CBUILD})
	export GOHOSTOS=$(go-env_goos ${CBUILD})
	export CC=$(tc-getBUILD_CC)

	export GOARCH=$(go-env_goarch)
	export GOOS=$(go-env_goos)
	export CC_FOR_TARGET=$(tc-getCC)
	export CXX_FOR_TARGET=$(tc-getCXX)
	use arm && export GOARM=$(go-env_goarm)
	use x86 && export GO386=$(go-env_go386)

	cd src
	bash -x ./make.bash || die "build failed"
}

src_test() {
	go_cross_compile && return 0
	cd src
	PATH="${GOBIN}:${PATH}" \
	./run.bash -no-rebuild -k || die "tests failed"
}

src_install() {
	dodir /usr/lib/go
	# The use of cp is deliberate in order to retain permissions
	cp -R . "${ED}"/usr/lib/go
	einstalldocs

	# testdata directories are not needed on the installed system
	# The other files we remove are installed by einstalldocs
	rm -r $(find "${ED}"/usr/lib/go -iname testdata -type d -print) || die
	rm "${ED}"/usr/lib/go/{CONTRIBUTING.md,PATENTS,README.md} || die
	rm "${ED}"/usr/lib/go/{SECURITY.md,codereview.cfg,LICENSE} || die

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
}
