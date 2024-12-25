# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nginx-module.eclass
# @MAINTAINER:
# Zurab Kvachadze <zurabid2016@gmail.com>
# @AUTHOR:
# Zurab Kvachadze <zurabid2016@gmail.com>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: toolchain-funcs flag-o-matic
# @BLURB: Provides a common set of functions for building NGINX's dynamic modules
# @DESCRIPTION:
# The nginx-module.eclass automates configuring, building and installing NGINX's
# dynamic modules. Using this eclass is as simple as calling 'inherit nginx-module'.
#
# This eclass automatically adds dependency on NGINX. If the part of the
# module's functionality depends on the NGINX configuration (e.g.
# HMAC generation support depending on http_ssl module being enabled), the
# corresponding code should be rewritten so that the functionality in question
# (1) is unconditionally enabled/disabled or (2) could be toggled by a USE flag.
#
# If the module makes use of the ngx_devel_kit (NDK), it must make sure to
# add that to the relevant *DEPEND variables and to call "append-cflags -DNDK",
# since (obviously) the NDK is not built alongside the module.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_NGINX_MODULE_ECLASS} ]]; then
_NGINX_MODULE_ECLASS=1

inherit toolchain-funcs flag-o-matic

# @FUNCTION: econf_ngx
# @USAGE: [<args>...]
# @DESCRIPTION:
# Call ./configure, passing the supplied arguments.
# The NGINX's build system consists of many helper scripts, which are executed
# relative to the working directory. Therefore, the function only supports
# executing the configure script from the current working directory. This
# function also checks whether the script is executable. If any of the above
# conditions are not satisfied, the function aborts the build process with
# 'die'. It also fails if the script itself exits with a non-zero exit code,
# unless the function is called with 'nonfatal'.
# If running ./configure is required, this is the way it should be done.
econf_ngx() {
	debug-print-function "${FUNCNAME[0]}" "$@"
	[[ ! -x ./configure ]] &&
		die "./configure is not present in the current working directory or is not executable"
	# We do not use edo here, as it does not quote its arguments when outputting
	# to stderr. This makes it harder to differentiate boundaries between
	# options that are supplied an argument containing whitespace.
	#
	# For example, if edo was used, the following Bash line:
	#     econf_ngx --with-cpp="gcc -E" --builddir=build
	# would be printed to stderr as
	#     ./configure --with-cpp=gcc -E --builddir=build
	# whilst the Bash's "${variable@Q}" syntax automatically quotes `variable`,
	# producing the following result:
	#     ./configure '--with-cpp=gcc -E' '--builddir=build'
	echo "./configure ${*@Q}" >&2
	./configure "$@"
	# For some reason, NGINX's ./configure returns 1 if it is used with the
	# '--help' argument.
	if [[ $? -ne 0 && "$1" != --help ]]; then
		die -n "./configure ${*@Q} failed"
	fi
}

# As per upstream documentation, modules must be rebuilt with each NGINX
# upgrade.
DEPEND="
	www-servers/nginx:=[modules(-)]
"
BDEPEND="${DEPEND}"
RDEPEND="${DEPEND}"

# @ECLASS_VARIABLE: NGINX_MOD_S
# @DESCRIPTION:
# Holds the path to the module's build directory, used in the
# nginx-module_src_configure() phase function. If unset at the time of inherit,
# defaults to ${S}. Can be changed by the ebuild.
: "${NGINX_MOD_S=${S}}"

# The ${S} variable is set to the path of the directory where the actual build
# will be performed. In this directory, symbolic links to NGINX's build system
# and NGINX's headers are created by the nginx-module_src_unpack() phase
# function.
S="${WORKDIR}/nginx"

# @ECLASS_VARIABLE: NGINX_MOD_SHARED_OBJECTS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# An array containing the basenames of all the compiled modules (shared objects
# with the extension ".so"). For some modules, may consist of more than element.
#
# This variable is set in the nginx-module_src_compile() function. Its contents
# are undefined before that.

# @FUNCTION: nginx-module_src_unpack
# @DESCRIPTION:
# Unpacks the sources and sets up the build directory in S=${WORKDIR}/nginx.
# Creates the following symbolic links (to not copy the files over):
#  - '${S}/src' -> '/usr/include/nginx',
#  - '${S}/auto' -> '/usr/src/nginx/auto',
#  - '${S}/configure' -> '/usr/src/nginx/configure'.
# For additional information, see nginx.eclass source, namely
# nginx_src_install() function.
nginx-module_src_unpack() {
	default_src_unpack
	mkdir nginx || die "mkdir failed"
	ln -s "${BROOT}/usr/src/nginx/configure" nginx/configure || die "ln failed"
	ln -s "${BROOT}/usr/src/nginx/auto" nginx/auto || die "ln failed"
	ln -s "${ESYSROOT}/usr/include/nginx" nginx/src || die "ln failed"
}

# @FUNCTION: nginx-module_src_prepare
# @DESCRIPTION:
# Patches module's initialisation code so that any module's preprocessor
# definitions appear in the separate '__ngx_gentoo_mod_config.h' file inside the
# 'build' directory. This function also makes module's "config" script clear
# whatever content build/ngx_auto_config.h may have at the time of invocation.
# Then, default_src_prepare() is called.
nginx-module_src_prepare() {
	pushd "${NGINX_MOD_S}" >/dev/null || die "pushd failed"
	# Since NGINX does not guarantee ABI or API stability, we utilise
	# preprocessor definitions that were used to compile NGINX itself, to build
	# third party modules. As such, we do not want for the dummy preprocessor
	# defines produced by NGINX build system during module compilation to leak
	# into the building environment. However, we do need to "capture"
	# preprocessor defines (CPP defines) set by the module itself, so we are
	# required to somehow get these separately.
	#
	# To achieve that, the following sed script inserts ': >
	# build/ngx_auto_config.h' line at the start of a module's 'config' shell
	# script which gets sourced by NGINX build system midway during
	# configuration. It has an effect of truncating the file containing NGINX
	# CPP defines. This results in the file containing only module's defines at
	# the end of the module's configuration.
	#
	# The following command renames the file with module's CPP defines to
	# __ngx_gentoo_mod_config to be later merged with the system NGINX header
	# into the actual header used during compilation. Due to the fact that
	# executing the config shell script is not the last thing that NGINX build
	# system does during configuration, we can not simply rename the header
	# after the whole configuration, as it may contain other CPP defines than
	# only the module's ones.
	sed -i -e '1i\' -e ': > build/ngx_auto_config.h' config ||
		die "sed failed"
	echo 'mv build/ngx_auto_config.h build/__ngx_gentoo_mod_config.h' \
		>> config || die "echo failed"
	default_src_prepare
	popd >/dev/null || die "popd failed"
}

# @FUNCTION: nginx-module_src_configure
# @DESCRIPTION:
# Configures the dynamic module(s) by calling NGINX's ./configure script.
# Custom flags can be supplied via the 'myconf' array, taking precedence over
# eclass's flags.
# This assembles ngx_auto_config.h from the system ngx_auto_config.h and
# __ngx_gentoo_mod_config.h (see nginx-module_src_prepare()), and
# ngx_auto_headers.h from the system ngx_auto_headers.h.
nginx-module_src_configure() {
	local ngx_mod_flags
	ngx_mod_flags=(
		--with-cc="$(tc-getCC)"
		--with-cpp="$(tc-getCPP)"
		# The '-isystem' flag is used instead of '-I', so as for the installed
		# (system) modules' headers to be of lower priority than the headers of
		# the currently built module. This only affects the modules that both
		# come with and install their own headers, e.g. ngx_devel_kit.
		--with-cc-opt="-isystem src/modules"
		--with-ld-opt="${LDFLAGS}"
		--builddir=build
		--add-dynamic-module="${NGINX_MOD_S}"
	)

	# NGINX build system adds directories under src/ to the include path based
	# on the specified configuration flags. Since nginx.eclass does not
	# save/restore the configuration flags, we have to add the directories to
	# the include path manually.
	# The src/os is added automatically by the auto/unix script and the
	# src/modules directory is included by the '--with-cc-opt' configuration
	# flag.
	append-cflags "$(find -H src -mindepth 1 -type d \! \( \( -path 'src/os' -o \
						-path 'src/modules' \) -prune \) -printf '-I %p ')"

	eval "local -a EXTRA_ECONF=( ${EXTRA_ECONF} )"

	# Setting the required environmental variables to skip the unneeded
	# execution of certain scripts (see nginx_src_install() in nginx.eclass).
	_NGINX_GENTOO_SKIP_PHASES=1 econf_ngx \
		"${ngx_mod_flags[@]}"	\
		"${myconf[@]}"			\
		"${EXTRA_ECONF[@]}"

	cat "${ESYSROOT}/usr/include/nginx/ngx_auto_config.h" \
		build/__ngx_gentoo_mod_config.h > build/ngx_auto_config.h ||
		die "cat failed"
	cp "${ESYSROOT}/usr/include/nginx/ngx_auto_headers.h" build ||
		die "cp failed"
}

# @FUNCTION: nginx-module_src_compile
# @DESCRIPTION:
# Compiles the module(s) by calling "make modules".
nginx-module_src_compile() {
	emake modules
	# Save the basenames of all the compiled modules into the
	# 'NGINX_MOD_SHARED_OBJECTS' array.
	mapfile -d '' NGINX_MOD_SHARED_OBJECTS < \
		<(find -H "${S}/build" -maxdepth 1 -type f -name '*.so' -printf '%P\0')
}

# @FUNCTION: nginx-module_src_install
# @DESCRIPTION:
# Installs the compiled module(s) into /usr/${libdir}/nginx/modules.
nginx-module_src_install() {
	insinto "/usr/$(get_libdir)/nginx/modules"
	doins build/*.so
}

# @FUNCTION: nginx-module_pkg_postinst
# @DESCRIPTION:
# Shows the instructions on how to enable and use the just-compiled module.
nginx-module_pkg_postinst() {
	local mod

	elog "${PN} has been compiled."
	elog ""
	elog "To utilise the module, add the following line(s) to the NGINX"
	elog "configuration file, which by default is \"${EROOT}/etc/nginx/nginx.conf\":"
	elog ""
	for mod in "${NGINX_MOD_SHARED_OBJECTS[@]}"; do
		elog "    load_module modules/${mod};"
	done
}

fi

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install pkg_postinst
