# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# pypy3 needs to be built using python 2
PYTHON_COMPAT=( python2_7 )
inherit check-reqs pax-utils python-any-r1 toolchain-funcs

PYPY_PV=${PV%_p*}
MY_P=pypy3.9-v${PYPY_PV/_}
PATCHSET="pypy3.9-gentoo-patches-${PV/%_p*}_p6"

DESCRIPTION="PyPy3 executable (build from source)"
HOMEPAGE="https://www.pypy.org/"
SRC_URI="
	https://buildbot.pypy.org/pypy/${MY_P}-src.tar.bz2
	https://dev.gentoo.org/~mgorny/dist/python/${PATCHSET}.tar.xz
"
S="${WORKDIR}/${MY_P}-src"

LICENSE="MIT"
SLOT="3.9-${PYPY_PV}"
KEYWORDS="amd64 ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+jit low-memory ncurses cpu_flags_x86_sse2"

RDEPEND="
	app-arch/bzip2:0=
	dev-libs/expat:0=
	dev-libs/libffi:0=
	>=sys-libs/zlib-1.1.3:0=
	virtual/libintl:0=
	ncurses? ( sys-libs/ncurses:0= )
	!dev-python/pypy3-exe-bin:${SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	low-memory? ( dev-python/pypy )
	!low-memory? (
		|| (
			dev-python/pypy
			dev-lang/python:2.7
		)
	)
"

check_env() {
	if use low-memory; then
		CHECKREQS_MEMORY="1750M"
		use amd64 && CHECKREQS_MEMORY="3500M"
	else
		CHECKREQS_MEMORY="3G"
		use amd64 && CHECKREQS_MEMORY="6G"
	fi

	check-reqs_pkg_pretend
}

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && check_env
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		check_env

		# unset to allow forcing pypy below :)
		use low-memory && EPYTHON=
		if [[ ! ${EPYTHON} || ${EPYTHON} == pypy ]] &&
				{ has_version -b dev-python/pypy ||
				has_version -b dev-python/pypy-bin; }
		then
			einfo "Using PyPy to perform the translation."
			EPYTHON=pypy
		else
			einfo "Using ${EPYTHON:-python2} to perform the translation. Please note that upstream"
			einfo "recommends using PyPy for that. If you wish to do so, please install"
			einfo "dev-python/pypy and ensure that EPYTHON variable is unset."
			python-any-r1_pkg_setup
		fi
	fi
}

src_prepare() {
	local PATCHES=(
		"${WORKDIR}/${PATCHSET}"
	)
	default
}

src_configure() {
	tc-export CC

	local jit_backend
	if use jit; then
		jit_backend='--jit-backend='

		# We only need the explicit sse2 switch for x86.
		# On other arches we can rely on autodetection which uses
		# compiler macros. Plus, --jit-backend= doesn't accept all
		# the modern values...

		if use x86; then
			if use cpu_flags_x86_sse2; then
				jit_backend+=x86
			else
				jit_backend+=x86-without-sse2
			fi
		else
			jit_backend+=auto
		fi
	fi

	local args=(
		--no-shared
		$(usex jit -Ojit -O2)

		${jit_backend}

		pypy/goal/targetpypystandalone
		--withmod-bz2
		$(usex ncurses --with{,out}mod-_minimal_curses)
	)

	local interp=( "${EPYTHON}" )
	if use low-memory; then
		interp=( env PYPY_GC_MAX_DELTA=200MB
			"${EPYTHON}" --jit loop_longevity=300 )
	fi

	if [[ ${EPYTHON} != pypy ]]; then
		# reuse bundled pycparser to avoid external dep
		mkdir -p "${T}"/pymod || die
		cp -r lib_pypy/cffi/_pycparser "${T}"/pymod/pycparser || die
		local -x PYTHONPATH=${T}/pymod:${PYTHONPATH}
	fi

	# translate into the C sources
	# we're going to build them ourselves since otherwise pypy does not
	# free up the unneeded memory before spawning the compiler
	set -- "${interp[@]}" rpython/bin/rpython --batch --source "${args[@]}"
	echo -e "\033[1m${@}\033[0m"
	"${@}" || die "translation failed"
}

src_compile() {
	emake -C "${T}"/usession*-0/testing_1
}

src_install() {
	cd "${T}"/usession*-0 || die
	newbin testing_1/pypy3.9-c pypy3.9-c-${PYPY_PV}
	insinto /usr/include/pypy3.9/${PYPY_PV}
	doins *.h
	pax-mark m "${ED}/usr/bin/pypy3.9-c-${PYPY_PV}"
}
