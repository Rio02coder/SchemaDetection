node User {
    has name: str;
    has city: str;
    has age: int;
}

walker users {
    has age: str;
    can get_users_with_age with `root entry {
        filtered_users = [here --> (`?User)](?age==self.age);
        print(filtered_users);
    }

    # can get_users_with_age with `root entry {
    #     all_users = [here --> (`?User)];
    #     filtered_users = [];
    #     for user in all_users {
    #         if(user.age == self.age) {
    #             filtered_users.append(user);
    #         }
    #     }
    #     print(filtered_users);
    # }

    # can has_age(user: User) {
    #     return user.age == self.age;
    # }
    # can get_users_with_age with `root entry {
    #     all_users = [here --> (`?User)];
    #     filtered_users = list(filter(self.has_age, all_users));
    #     print(filtered_users);
    # }

    # can get_users_with_age with `root entry {
    #     all_nodes = [here -->];
    #     filtered_users = [];
    #     for node_obj in all_nodes {
    #         if isinstance(node_obj, User) && node_obj.age == self.age {
    #             filtered_users.append(node_obj);
    #         }
    #     }
    #     print(filtered_users);
    # }


    can is_user_with_age(node_obj: node) {
        return isinstance(node_obj, User) && node_obj.age == self.age;
    }
    can get_users_with_age with `root entry {
        all_nodes = [here -->];
        filtered_users = list(filter(self.is_user_with_city, all_nodes));
        print(filtered_users);
    }
}

with entry {
    user_1 = User(name="ABC", city="Ann Arbor", age=22);
    user_2 = User(name="BCD", city="New York", age=30);
    user_3 = User(name="CDE", city="Ann Arbor", age=40);

    root ++> user_1;
    root ++> user_2;
    root ++> user_3;

    root spawn users(age="Ann Arbor");
}