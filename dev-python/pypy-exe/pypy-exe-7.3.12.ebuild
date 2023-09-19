# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs pax-utils toolchain-funcs

PYPY_PV=${PV%_p*}
MY_P=pypy2.7-v${PYPY_PV/_}
PATCHSET="pypy2.7-gentoo-patches-${PV/_}"

DESCRIPTION="PyPy executable (build from source)"
HOMEPAGE="https://www.pypy.org/"
SRC_URI="
	https://buildbot.pypy.org/pypy/${MY_P}-src.tar.bz2
	https://dev.gentoo.org/~mgorny/dist/python/${PATCHSET}.tar.xz
"
S="${WORKDIR}/${MY_P}-src"

LICENSE="MIT"
SLOT="${PYPY_PV}"
KEYWORDS="amd64 ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 +jit low-memory ncurses cpu_flags_x86_sse2"

DEPEND="
	>=sys-libs/zlib-1.1.3:0=
	dev-libs/libffi:0=
	virtual/libintl:0=
	dev-libs/expat:0=
	bzip2? ( app-arch/bzip2:0= )
	ncurses? ( sys-libs/ncurses:0= )
"
RDEPEND="
	${DEPEND}
	!dev-python/pypy-exe-bin:${PYPY_PV}
"
# don't enforce the dep on dev-python/pypy with USE=low-memory
# since it's going to cause circular dep with unhelpful error message
BDEPEND="
	!low-memory? (
		|| (
			dev-python/pypy
			dev-lang/python:2.7
		)
	)
"

check_env() {
	if ! has_version -b dev-python/pypy; then
		if use low-memory; then
			eerror "USE=low-memory requires (a prior version of) dev-python/pypy"
			eerror "installed."
		else
			ewarn "CPython 2.7 will be used to perform the translation.  Upstream"
			ewarn "recommends using (a prior version of) dev-python/pypy instead."
		fi
		elog "You can install a prebuilt version of PyPy first using e.g.:"
		elog "  $ emerge -1v dev-python/pypy dev-python/pypy-exe-bin"

		if use low-memory; then
			die "dev-python/pypy needs to be installed for USE=low-memory"
		fi
	fi

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
	[[ ${MERGE_TYPE} != binary ]] && check_env
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
	)

	# Avoid linking against libraries disabled by use flags
	local opts=(
		bzip2:bz2
		ncurses:_minimal_curses
	)

	local opt
	for opt in "${opts[@]}"; do
		local flag=${opt%:*}
		local mod=${opt#*:}

		args+=(
			$(usex ${flag} --withmod --withoutmod)-${mod}
		)
	done

	local interp
	if use low-memory || has_version -b dev-python/pypy; then
		einfo "Using already-installed PyPy to perform the translation."
		interp=( pypy )
		if use low-memory; then
			local -x PYPY_GC_MAX_DELTA=200MB
			interp+=( --jit loop_longevity=300 )
		fi
	else
		einfo "Using CPython 2.7 to perform the translation."
		interp=( python2.7 )

		# reuse bundled pycparser to avoid external dep
		mkdir -p "${T}"/pymod/cffi || die
		: > "${T}"/pymod/cffi/__init__.py || die
		cp -r lib_pypy/cffi/_pycparser "${T}"/pymod/cffi/ || die
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
	local dest=/usr/lib/pypy2.7
	exeinto "${dest}"
	newexe "${T}"/usession*-0/testing_1/pypy-c pypy-c-${PYPY_PV}
	insinto "${dest}"/include/${PYPY_PV}
	doins include/pypy_*
	pax-mark m "${ED}${dest}/pypy-c-${PYPY_PV}"
}
