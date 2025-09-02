
# ---- Project
NAME        := ircserv

CXX         := c++
RM          := rm -rf

CXXSTD      := -std=c++98
CXXWARN     := -Wall -Wextra -Werror

# ---- OS / Platform detection
UNAME_S     := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
  PLATFORM  := macos
  CXXDEFS   := -DFTIRC_MACOS
else
  PLATFORM  := linux
  CXXDEFS   := -DFTIRC_LINUX
endif

# ---- Sources (all *.cpp except under build/)
SRCS        := $(shell find . -type f -name '*.cpp' -not -path './build/*')
BUILD_DIR   := build/$(PLATFORM)
OBJS        := $(patsubst ./%.cpp,$(BUILD_DIR)/%.o,$(SRCS))
DEPS        := $(OBJS:.o=.d)

# ---- Flags
CXXFLAGS    := $(CXXSTD) $(CXXWARN) $(CXXDEFS)

# ---- Phony
.PHONY: all clean fclean re

# ---- Default
all: $(NAME)

# ---- Link
$(NAME): $(OBJS)
	@echo "  [LINK] $@"
	@$(CXX) $(OBJS) -o $@ $(LDFLAGS)

# ---- Compile (dep generation)
$(BUILD_DIR)/%.o: ./%.cpp
	@mkdir -p $(dir $@)
	@echo "  [CXX ] $<"
	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) -MMD -MP -c $< -o $@

# ---- Utilities
clean:
	@echo "  [CLEAN] objects"
	@$(RM) $(BUILD_DIR)

fclean: clean
	@echo "  [FCLEAN] $(NAME)"
	@$(RM) $(NAME)

re: fclean all

