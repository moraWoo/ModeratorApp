//
//  UserListView.swift
//  ModeratorApp
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import SwiftUI
import SwiftData

struct UserListView: View {
    @ObservedObject var viewModel: UserListViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var hasInitialized = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Moderator")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.horizontal, .top])
                    
                    CustomTabSwitch(selection: $viewModel.selectedTab)
                        .padding(.top)
                }
                
                UserSearchView(
                    searchText: $viewModel.searchText,
                    placeholder: "Search"
                )
                .padding(.vertical)
                .padding(.horizontal, 18)
                
                ZStack {
                    if viewModel.isLoading {
                        LoadingView()
                    } else if viewModel.users.isEmpty {
                        EmptyStateView()
                    } else {
                        List {
                            ForEach(viewModel.users) { user in
                                UserListItem(user: user) {
                                    viewModel.onUserTapped(user: user)
                                }
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        viewModel.toggleAdmin(for: user)
                                    } label: {
                                        Image(user.isAdmin ? Asset.unadminUser.name : Asset.adminUser.name)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 80, height: 80)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    }
                                    .tint(.clear)
                                    .frame(width: 80)
                                    
                                    Button {
                                        viewModel.toggleBanned(for: user)
                                    } label: {
                                        Image(user.isBanned ? Asset.unblockUser.name : Asset.blockUser.name)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 80, height: 80)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    }
                                    .tint(.clear)
                                    .frame(width: 80)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            
            TooltipOverlay(
                showTooltip: viewModel.selectedTab == 0 ? viewModel.showAllUsersTooltip : (viewModel.selectedTab == 1 ? viewModel.showAdminsTooltip : false),
                selectedTab: viewModel.selectedTab,
                onTooltipButtonTap: {
                    if viewModel.selectedTab == 0 {
                        viewModel.markAllUsersTooltipAsShown()
                    } else {
                        viewModel.markAdminsTooltipAsShown()
                    }
                }
            )
        }
        .onAppear {
            if !hasInitialized {
                viewModel.initializeWithModelContext(modelContext)
                hasInitialized = true
            }
        }
        .refreshable {
            viewModel.refreshUsers()
        }
    }
}
